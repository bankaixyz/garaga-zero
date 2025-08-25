# Garaga Zero

Cairo Zero version library of [garaga](https://github.com/keep-starknet-strange/garaga).
Made for the most efficient local proving performance.

## Build Instructions

### Setup Environment
```bash
make setup
source venv/bin/activate
```

### Build Cairo Zero Circuits
Generate the defined circuits in Cairo Zero:

```bash
python3 precompiled_circuits/compilable_circuits/fustat_only.py
python3 precompiled_circuits/all_circuits.py
```

## Available Hints

This project provides a comprehensive set of hints for efficient Cairo Zero execution:

- **Circuit Operations**: Modulo circuits and extension field operations
- **Basic Field Operations**: Arithmetic operations, equality checks, and modular operations
- **Hash to Curve**: G2 curve mapping operations
- **Utilities**: Output retrieval, memory operations, and transcript handling

**Note**: Running the Rust VM requires the Python environment to be active, as witnesses need to be precomputed in Python.
