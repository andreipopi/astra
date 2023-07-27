
## ASTRA - Assumption-based argumentation Solver using Tree-decompositions to Answer reasoning tasks

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

ASTRA is an approach to assumption-based argumentation (ABA) that exploits tree-decompositions for reasoning. ASTRA uses DFLAT, a framework that allows solving reasoning tasks using dynamic programming, by specifying the dynamic programming algorithm in ASP. This algorithm is executed on a tree-decomposition of the problem instance.

We provide dynamic algorithms as encodings for the supported reasoning tasks, a generator of instances, and an archive containg the instances on which we preliminarily evaluated the approach.

# Citation
``` TBD```

## What you need

    - terminal
    - D-FLAT (https://dbai.tuwien.ac.at/proj/dflat/system/)
    - an encoding
    - an instance

## Usage


## Problem Instance and Query

A problem instance is a hypergraph specified in terms of ASP predicates. See running_example.lp.
You can include an atom to be queried through the query predicate directly in the problem instance.


## D-FLAT
D-FLAT is the ASP dynamic programming framework used in this work. A pre-compiled version of D-FLAT is available at: https://dbai.tuwien.ac.at/proj/dflat/system/. To run our algorithm, this version is sufficient.

## Supported Reasoning Tasks

The solver ASTRA supports the following ABA reasoning tasks:
• DC-CO, DC-ST: credulous acceptance under complete and stable semantics, and
• DC-CO, DC-ST: skeptical acceptance under complete and stable semantics, and
• SE-CO, SE-ST: return of one acceptable set under com- plete and stable semantics.

## Authors

Andrei Popescu (TU Graz) and Johannes Wallner (TU Graz). For questions or comments contact andrei.popescu@ist.tugraz.at.

## License

This software is released under the MIT License and copyrighted by the authors.