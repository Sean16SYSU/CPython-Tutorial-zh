def count(list arr):
    d = {}
    for n in arr:
        if n not in d:
            d[n] = 1
        else:
            d[n] += 1
    return d