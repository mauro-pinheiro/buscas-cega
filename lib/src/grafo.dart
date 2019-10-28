part of buscas;

E noElement<E>() => null;

//========================================================
class Vertice{
  String  _info;
  String  _label;
  int     _weight;

  Vertice(String info, String label, [int weight = 1]){
    this._info    = info;
    this._label   = label;
    this._weight  = weight;
  }
  set info(value)   => _info = value;
  
  String  get info    => _info;
  String  get label   => _label;
  int     get weight  => _weight;

  set weight(value) => _weight = value;

  @override
  bool operator == (o) => o is Vertice && o.label == _label;

  int get hashCode => _label.hashCode;

  @override
  String toString() {
    return label;
  }
}

//=======================================
class Edge{
  Vertice   _v1;
  Vertice   _v2;
  int       _weight;
  String    _label;

  Edge(Vertice v1, Vertice v2, String label, [int weight = 1]){
    this._v1      = v1;
    this._v2      = v2;
    this._weight  = weight;
    this._label   = label;
  }

  Vertice       get v1        => _v1;
  Vertice       get v2        => _v2;
  int           get weight    => _weight;
  String        get label     => _label;
  List<Vertice> get endPoints => [v1, v2];

  bool endVerticies(String v1, String v2) => _v1.label == v1 && _v2.label == v2;
  bool containsVertice(String v) => _v1.label == v || _v2.label == v;

  bool operator(o) => o is Edge && o.label == _label;

  @override
  int get hashCode => _label.hashCode;

  @override
  String toString() => label;
}


//======================================================
class Graph{  
  List<Vertice>             _vertices;
  List<Edge>                _edges;
  Map<Vertice, List<Edge>>  _adjacence;

  bool _digraph;

  Graph([bool digraph = false]){
    _vertices   = List<Vertice>();
    _edges      = List<Edge>();
    _adjacence  = Map<Vertice, List<Edge>>();
    _digraph = digraph;
  }

  void addVertice(Vertice v) {
    if(_vertices.contains(v)){
      throw Exception("Vertice duplicado!");
    }
    _addVertice(v);
  }

  Vertice vertice(String label) => _vertices.firstWhere((v) => v.label == label);
  Edge edge(String label) => _edges.firstWhere((e) => e.label == label);

  String  get vertices    => _vertices.toString();
  String  get edges       => _edges.toString();
  bool    get digraph     => _digraph;
 
 
 List<Vertice> adjacentVertices(String v) => 
  _adjacence[vertice(v)].where((e) => e.containsVertice(v))
                        .map((e) => e.endPoints.firstWhere((ver)=> ver.label != v))
                        .toList();

  bool containsVertice(String v) => vertice(v) is Vertice;

  Edge findEdge(String v, String u) => _edges.firstWhere((e) => e.containsVertice(v) && e.containsVertice(u));

  void _addVertice(Vertice v) => this.._vertices.add(v).._adjacence[v] = List<Edge>();

  void addEdge(Edge e){
    if(_edges.contains(e)){
      throw Exception("Aresta duplicada!");
    }

    if(!_vertices.contains(e.v1)){
      _addVertice(e.v1);
    }
    if(!_vertices.contains(e.v2)){
      _addVertice(e.v2);
    }
    _edges.add(e);
    
    _adjacence[e.v1].add(e);
    
    if(!_digraph){
      _adjacence[e.v2].add(e);
    }
  }

  List<Edge> ascedantEdge(String v) => _adjacence[vertice(v)];
  List<Edge> incidentEdge(String v){
    List<Edge> incidents = List<Edge>();
    for (var key in _adjacence.keys) {
      incidents.addAll(_adjacence[key].where((e) => e.v2 == vertice(v)));
    }
    return incidents;
  }

  Vertice opposite(String v, String e){
    if(_adjacence[vertice(v)].contains(edge(e))){
      if(edge(e).v1 == vertice(v)){
        return edge(e).v2;
      } 
      if(edge(e).v2 == vertice(v)) {
        return edge(e).v1;
      }
    }
    return null;
  }
}

class Path{
  List<Vertice> _path;

  Path(List<Vertice> path){
    _path = path;
  }

  @override
  String toString(){
    String str = "[";
    for(int i = 0; i < _path.length - 1; ++i){
      str += _path[i].toString() + " -> ";
    }
    str += _path.last.toString() + "]";
  }
}