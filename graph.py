#!/usr/bin/env python3

import json


class Nothing(Exception): pass


def _resolve_follows(nodes, path):
    if not path:
        raise Nothing
    node = "root"
    for component in path:
        node = nodes[node]["inputs"][component]
        if isinstance(node, list):
            node = _resolve_follows(nodes, node)
    return node


def resolve_follows(nodes, path):
    try:
        return _resolve_follows(nodes, path)
    except Nothing:
        return "(nothing)"


def main():
    with open('flake.lock') as f:
        lock = json.load(f)

    nodes = lock["nodes"]

    to_process = [lock["root"]]
    seen = {lock["root"], "(nothing)"}

    print("digraph G {")
    print('rankdir="LR";')
    while to_process:
        this = to_process.pop()
        node = nodes[this]
        for name, subinput in node.get("inputs", {}).items():
            if isinstance(subinput, list):
                subinput = resolve_follows(nodes, subinput)
            print(f'"{this}" -> "{subinput}" [label="{name}"];')
            if subinput not in seen:
                to_process.append(subinput)
                seen.add(subinput)

    print("}")


if __name__ == '__main__':
    main()
