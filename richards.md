# doIt
```smalltalk
Python evalInThread: 'from richards import main; main(iterations=1000)' cmd: 'exec'.
```

# Results

## PyPy
```
Total time for 1000 iterations: 2.73 secs
Average time per iteration: 2.73 ms
```

## RSqueak+PyPy
```
Total time for 1000 iterations: 152.11 secs
Average time per iteration: 152.11 ms
```
*Commit: 3025196f703f0e891591238f40d572d6ac58d9b1 (without print statements)*

## CPython
```
Total time for 1000 iterations: 163.57 secs
Average time per iteration: 163.57 ms
```

