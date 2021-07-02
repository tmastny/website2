from collections import deque

matrix = [
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
]

rows = len(matrix)
cols = len(matrix[0])

queue = deque([(0, 0)])

i = 1
while queue:
    r, c = queue.pop()
    if not matrix[r][c]:
        matrix[r][c] = i
        i += 1

    for nr, nc in [(r + 1, c), (r, c + 1)]:
        if 0 <= nr < rows and 0 <= nc < cols:
            queue.appendleft((nr, nc))


for row in matrix:
    for col in row:
        print(f"{col:>2}", end=" ")

    print()
