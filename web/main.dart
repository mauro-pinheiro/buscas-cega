import 'package:buscas_cega/buscas.dart';

void main() {
  //querySelector('#output').text = 'Your Dart app is running.';
  Graph graph = Graph();
  Vertice a = Vertice('12', 'a');
  Vertice b = Vertice('34', 'b');
  Vertice c = Vertice('56', 'c');
  Vertice d = Vertice('67', 'd');
  Vertice e = Vertice('78', 'e');
  Vertice f = Vertice('89', 'f');
  Vertice g = Vertice('90', 'g');

  Edge A = Edge(a, b, 'A');
  Edge B = Edge(a, c, 'B');
  Edge C = Edge(b, d, 'C');
  Edge D = Edge(b, e, 'D');
  Edge E = Edge(c, f, 'E');
  Edge F = Edge(c, g, 'F');

  graph
    ..addEdge(A)
    ..addEdge(B)
    ..addEdge(C)
    ..addEdge(D)
    ..addEdge(E)
    ..addEdge(F);

  Buscas busca = Buscas(graph, 'a', '90');

  print("Caminho solucao: ${busca.buscaEmProfundidadeInterativa()}");

  //print(graph.adjacentVertices('b'));

}
