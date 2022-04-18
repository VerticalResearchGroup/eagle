import torch
torch.ops.load_library("build/libadd_op_cpu.so")
a = torch.randn(3,3)
b = torch.randn(3,3)
print(torch.add(a,b))
print(torch.ops.eagle.add(a, b,1))