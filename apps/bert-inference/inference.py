import argparse
import torch
from transformers import BertTokenizer, BertForQuestionAnswering

def run_inference(args):
    tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")
    model = BertForQuestionAnswering.from_pretrained("bert-base-uncased")
    model.eval()

    inputs = tokenizer(args.question, args.text, return_tensors = "pt")

    with torch.no_grad():
        outputs = model(**inputs)

    answer_start_index = outputs.start_logits.argmax()
    answer_end_index = outputs.end_logits.argmax()

    predict_answer_tokens = inputs.input_ids[0, answer_start_index : answer_end_index + 1]
    decoded_outputs = tokenizer.decode(predict_answer_tokens)

    print(decoded_outputs)

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()

    arg_parser.add_argument("--question", default = '', type = str)
    arg_parser.add_argument("--text", default = '', type = str)

    args = arg_parser.parse_args()
    
    run_inference(args)