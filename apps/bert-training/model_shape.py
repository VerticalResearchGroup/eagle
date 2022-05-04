
import torch
import torch.nn as nn
import re
import sys
import os
from transformers import BertForPreTraining


def clean_class_name(x):
    return re.match(r"<class '((\w+|\.)+)'>", x).group(1)

def getInfo(model, inputs, file = sys.stdout):
        cols = {"operator name": 0,
                "in channels": 1,
                "out channels": 2,
                "filter size": 3,
                "stride": 4,
                "padding": 5,
        }
        layer_info = []

        def hook_fn(layer_name):
                def hook(m : nn.Module, input, output):
                        results = {}
                        results["operator name"] = layer_name

                        # shape
                        def infshape(name, params, isoutput=False):
                                if isinstance(params, torch.Tensor):
                                        params = [params]

                                for i, param in enumerate(params):
                                        col_name = name.format(i)
                                        if param is None:
                                                continue
                                        if col_name not in cols:
                                                cols[col_name] = len(cols)
                                        if hasattr(param, "shape"):
                                                results[col_name] = str('x'.join(map(str, param.shape)))
                                        else:
                                                results[col_name] = clean_class_name(str(type(param)))
                                        # only need one output -- all others are the same
                                        if isoutput:
                                            break

                        infshape("input{} shape", input)
                        infshape("param{} shape", m.parameters())
                        infshape("output{} shape", output, isoutput=True)

                        if type(m) is nn.Conv2d:
                                results["in channels"] = m.in_channels
                                results["out channels"] = m.out_channels
                                results["filter size"] = str('x'.join(map(str, m.kernel_size)))
                                results["stride"] = str('x'.join(map(str, m.stride)))
                                results["padding"] = str('x'.join(map(str, m.padding)))
                        layer_info.append(results)
                return hook

        hook_handles = []
        for n, m in model.named_modules():
                if isinstance(m, model.__class__):
                        continue
                elif isinstance(m, nn.Sequential):
                        continue
                elif isinstance(m, nn.ModuleList):
                        continue
                else:
                        hook_handles.append(m.register_forward_hook(hook_fn(n)))

        y_ = model(**inputs)

        for h in hook_handles:
                h.remove()

        # print header for csv
        col_seq = {}
        for col_name in cols:
                col_seq[cols[col_name]] = col_name
        col_list = []
        for i in range(len(col_seq)):
                col_list.append(col_seq[i])
        print(','.join(col_list), file=file)

        # print each line
        for layer in layer_info:
                print_info = []
                for col_name in col_list:
                        if col_name in layer:
                                print_info.append(str(layer[col_name]))
                        else:
                                print_info.append("")
                print(','.join(print_info), file=file)


model = BertForPreTraining.from_pretrained("bert-base-uncased")
input_ids = torch.randint(0, 10000, size = (1, 512)).long()
token_type_ids = torch.zeros(1, 512).long()
attention_mask = torch.ones(1, 512).long()

inputs = {
    "input_ids":input_ids,
    "token_type_ids":token_type_ids,
    "attention_mask":attention_mask
}

with open('bert-base-training.csv', 'w') as f:
    getInfo(model, inputs, f)


    
