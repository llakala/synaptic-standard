# Introduction

This page aims to specify the Synaptic Standard's core concepts in relation to
the established problems described in [Part 1](./first.md).

Note that the standard does not aim to declare a hard set of laws. Instead, the
goal of the standard is to provide some guiding principles for organizing one's
own NixOS configuration. Extensibility is also a core tenet: your own principles
will likely establish naturally as your config grows and adapts.

1. Treat all configuration equally
2. Organize your config directory based on semantics
3. Creating new files and folders should be painless
4. Leaves shouldn't be load-bearing without safeguards
5. Design for today, not tomorrow
