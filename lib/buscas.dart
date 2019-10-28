library buscas;

import 'dart:collection';

part 'src/grafo.dart';

class Buscas {
  Graph _grafo;
  String _startVertice;
  String _solution;

  Buscas(Graph grafo, String start, String solution) {
    _grafo = grafo;
    _startVertice = grafo.containsVertice(start) ? start : "";
    _solution = solution;
  }

  Graph get grafo => _grafo;

  List<Vertice> _expansaoNode(String v) => _grafo.adjacentVertices(v);

  bool _testSolution(String v) => grafo.vertice(v).info == _solution;

  List<Vertice> buscaEmLargura() {
    Vertice node = grafo.vertice(_startVertice);
    Queue<Vertice> frontier = Queue<Vertice>();
    Set<Vertice> visited = Set<Vertice>();

    frontier.add(node);
    visited.add(node);
    if (_testSolution(node.label)) {
      return visited.toList();
    }
    while (true) {
      if (frontier.isEmpty) {
        print("Falhou");
        return visited.toList();
      }
      node = frontier.removeFirst();
      List<Vertice> childs = _expansaoNode(node.label);
      for (var child in childs) {
        if (visited.add(child)) {
          print(visited);
          if (_testSolution(child.label)) {
            print("Solução é ${visited.last}");
            return visited.toList();
          }
          frontier.add(child);
        }
      }
    }
  }

  List<Vertice> buscaCustoUniforme() {
    Vertice node = grafo.vertice(_startVertice);
    List<Vertice> frontier = List<Vertice>();
    Set<Vertice> visited = Set<Vertice>();

    frontier.add(node);
    visited.add(node);
    if (_testSolution(node.label)) {
      return visited.toList();
    }
    while (true) {
      if (frontier.isEmpty) {
        print("Falhou");
        return visited.toList();
      }
      node = frontier.removeAt(0);
      List<Vertice> childs = _expansaoNode(node.label);
      for (var child in childs) {
        if (visited.add(child)) {
          child.weight += grafo.findEdge(node.label, child.label).weight;

          if (_testSolution(child.label)) {
            print("Solução é ${visited.last} com custo ${visited.last.weight}");
            return visited.toList();
          }
          frontier.add(child);
          frontier.sort((v, u) => v.weight.compareTo(u.weight));
        }
      }
    }
  }

  List<Vertice> buscaEmProfundidadeInterativa() {
    int limit = 0;
    dynamic result;
    while ((result = _buscaProfundidadeRecursiva(grafo.vertice(_startVertice),
            Set<Vertice>()..add(grafo.vertice(_startVertice)), limit))[1] ==
        "cut off") {
      limit++;
    }
    return result[0].toList();
  }

  List<Vertice> buscaEmProfundidade([int limit = -1]) {
    Set<Vertice> visited = Set<Vertice>()..add(grafo.vertice(_startVertice));
    dynamic result =
        _buscaProfundidadeRecursiva(visited.elementAt(0), visited, limit);
    return result[0].toList();
  }

  dynamic _buscaProfundidadeRecursiva(
      Vertice node, Set<Vertice> visited, int limit) {
    if (_testSolution(node.label)) {
      return [visited, "Sucesso"];
    }

    if (limit == 0) {
      return [visited, "cut off"];
    }

    List<Vertice> childs = _expansaoNode(node.label);

    bool cutoff = false;

    for (var child in childs) {
      if (visited.add(child)) {
        dynamic result = _buscaProfundidadeRecursiva(child, visited, limit - 1);
        if (result[1] == "cut off") {
          cutoff = true;
        }
        if (result[1] != "Falha") {
          return result;
        }
      }
    }
    if (cutoff) {
      return [visited, "cut off"];
    } else {
      return [visited, "Falha"];
    }
  }
}
