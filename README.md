
# ASTRA

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)

> This is the maintained GitHub repository for ASTRA. The project was originally published in the [TU Graz Knowledge Representation and Reasoning (KRR) GitLab repository](https://gitlab.tugraz.at/krr/astra).

ASTRA (Assumption-based argumentation Solver using Tree-decompositions to Answer reasoning tasks) is a prototype for reasoning in assumption-based argumentation (ABA) using dynamic programming over tree decompositions. Its algorithms are specified as answer set programming (ASP) encodings and executed by [D-FLAT](https://www.dbai.tuwien.ac.at/proj/dflat/system/). The approach is designed to exploit the structure of ABA instances with low treewidth.

The repository contains the encodings for the supported reasoning tasks, an instance generator, a running example, and the instances used in the preliminary evaluation.

## Publication

**[Reasoning in Assumption-Based Argumentation Using Tree-Decompositions](https://link.springer.com/chapter/10.1007/978-3-031-43619-2_14)**

Andrei Popescu and Johannes P. Wallner. JELIA 2023, LNCS 14281, pages 192–208.

The version with the appendix is available in the [original project repository](https://gitlab.tugraz.at/krr/astra/-/blob/main/Paper/Reasoning%20in%20Assumption-based%20Argumentation%20using%20Tree-decompositions.pdf).

## Repository contents

- [`Encodings/`](Encodings/) contains the D-FLAT encodings.
- [`running_example.lp`](running_example.lp) is the ABA instance used in the examples below.
- [`Generator/`](Generator/) contains the random instance generator.
- [`instances.zip`](instances.zip) contains the instances used in the preliminary evaluation.

## Supported reasoning tasks

ASTRA supports the following tasks under admissible (`adm`), complete (`com`), and stable (`stb`) semantics:

- enumeration and counting of assumption sets;
- credulous acceptance of a query atom;
- skeptical acceptance of a query atom.

## Requirements

- A terminal
- [D-FLAT](https://www.dbai.tuwien.ac.at/proj/dflat/system/)

D-FLAT handles the tree decomposition and executes the ASP encoding at each decomposition node. Precompiled versions are available from the D-FLAT project page. The required hyperedge predicates are declared in the `%dflat:` line at the start of each encoding.

## Usage

Run D-FLAT from its main directory and replace `/path/to/astra` with the path to this repository.

Enumerate admissible assumption sets:

```bash
./dflat -p /path/to/astra/Encodings/adm-enum.lp \
  < /path/to/astra/running_example.lp
```

Check credulous acceptance under complete semantics:

```bash
./dflat -p /path/to/astra/Encodings/com-cred.lp \
  < /path/to/astra/running_example.lp
```

Check skeptical acceptance under complete semantics:

```bash
./dflat -p /path/to/astra/Encodings/com-skept.lp \
  < /path/to/astra/running_example.lp
```

Use the corresponding encoding in [`Encodings/`](Encodings/) to change the semantics or reasoning task. Useful D-FLAT options include:

- `--print-decomposition` prints the generated tree decomposition.
- `--output human` shows computed tables and extension pointers in human-readable form.
- `--output machine` shows the same information in machine-readable form.
- `--depth 0` shows only the number of solutions.

Run `./dflat -h` for the complete list of options.

## Instance format

An ABA instance is represented as a hypergraph using ASP facts. The format uses `assumption/1`, `atom/1`, and `rule/1` to declare objects, and `head/2`, `body/2`, and `contrary/2` to describe the ABA framework. See [`running_example.lp`](running_example.lp) for a complete example.

Credulous and skeptical acceptance encodings read the queried atom from the unary `query/1` predicate in the instance.

## Citation

```bibtex
@inproceedings{PopescuW23,
  author    = {Andrei Popescu and Johannes P. Wallner},
  editor    = {Sarah Alice Gaggl and Maria Vanina Martinez and Magdalena Ortiz},
  title     = {Reasoning in Assumption-Based Argumentation Using Tree-Decompositions},
  booktitle = {Logics in Artificial Intelligence},
  series    = {Lecture Notes in Computer Science},
  volume    = {14281},
  pages     = {192--208},
  publisher = {Springer},
  year      = {2023},
  doi       = {10.1007/978-3-031-43619-2_14}
}
```

## Authors

Andrei Popescu (TU Graz) and Johannes P. Wallner (TU Graz). For questions or comments, contact [andrei.popescu@ist.tugraz.at](mailto:andrei.popescu@ist.tugraz.at).

## License

This software is released under the [MIT License](LICENSE.md). D-FLAT is distributed under its own license.
