
## ASTRA - Assumption-based argumentation Solver using Tree-decompositions to Answer reasoning tasks

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

ASTRA is an approach to assumption-based argumentation (ABA) that exploits tree-decompositions for reasoning. ASTRA uses DFLAT, a framework that allows solving reasoning tasks using dynamic programming, by specifying the dynamic programming algorithm in ASP. This algorithm is executed on a tree-decomposition of the problem instance.

We provide dynamic algorithms as encodings for the supported reasoning tasks, a generator of instances, and an archive containg the instances on which we preliminarily evaluated the approach.

[Paper with appendix](https://gitlab.tugraz.at/krr/astra/-/blob/main/Paper/Reasoning%20in%20Assumption-based%20Argumentation%20using%20Tree-decompositions.pdf)

# Citation
Andrei Popescu and Johannes P. Wallner. Reasoning in Assumption-based Argumentation using Tree-decompositions. In Vanina Martinez, Magdalena Ortiz, and Sarah A. Gaggl, editors, Proceedings of the 18th European Conference on Logics in Artificial Intelligence, JELIA 2023, volume 14281 of Lecture Notes in Computer Science pages XXX-YYY, Dresden, Germany, 2023. Springer.

## Supported Reasoning Tasks

ASTRA supports the following ABA reasoning tasks:

- Return of **acceptable sets** under **[ADM, ST, CO]**.

- **Credulous Reasoning**: credulous acceptance of a query atom under a specific semantics [ADM, ST, CO].

- **Skeptical Reasoning**: skeptical acceptance of a query atom under a specific semantics [ADM, ST, CO].


## What you need

- terminal
- [D-FLAT](https://dbai.tuwien.ac.at/proj/dflat/system/)
- an encoding (e.g. [adm-enum.lp](https://gitlab.tugraz.at/krr/astra/-/blob/main/Encodings/Admissible.lp))
- an instance (e.g. [running_example.lp](https://gitlab.tugraz.at/krr/astra/-/blob/main/running_example.lp)

## Usage

1. Clone astra
2. Download D-FLAT
3. In the D-FLAT main folder run the following:

- for extensions under a semantics (example ADM):

```./dflat -p path_to_astra_parent/astra/Encodings/adm-enum.lp < path_to_astra_parent/astra/running_example.lp```

- for credulous acceptance under a semantics (example CO):

```./dflat -p path_to_astra_parent/astra/Encodings/com-cred.lp < path_to_astra_parent/astra/running_example.lp```

- for skeptical acceptance under a semantics (example CO):

```./dflat -p path_to_astra_parent/astra/Encodings/com-skept.lp < path_to_astra_parent/astra/running_example.lp```

In addition, as outlined by the D-FLAT [documentation](https://dbai.tuwien.ac.at/research/report/dbai-tr-2017-107.pdf), you can obtain additional details on the tree decomposition, computed tables at each nodes, and even low-level information about D-FLAT's computed extension pointers, through the following options.

```--print-decomposition```

```--output human```

```--output machine```

To only visualise the number of solutions, use:

```--depth 0```


## Problem Instance and Query

A problem instance is a hypergraph specified in terms of ASP predicates. See [running_example.lp](https://gitlab.tugraz.at/krr/astra/-/blob/main/running_example.lp).

For credulous and skeptical acceptance, you can include the atom to be queried through the unary ```query``` predicate directly in the problem instance.


## D-FLAT
D-FLAT is the ASP dynamic programming framework used in this work. A pre-compiled version of D-FLAT is available at: https://dbai.tuwien.ac.at/proj/dflat/system/. To run our algorithm, this version is sufficient.


## Authors

Andrei Popescu (TU Graz) and Johannes Wallner (TU Graz). For questions or comments contact andrei.popescu@ist.tugraz.at.

## License

This software is released under the MIT License and copyrighted by the authors. Note that DFLAT is distributed under its own license.