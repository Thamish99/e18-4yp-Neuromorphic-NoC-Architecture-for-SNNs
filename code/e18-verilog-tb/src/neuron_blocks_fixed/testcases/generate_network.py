import networkx as nx
import matplotlib.pyplot as plt

G = nx.DiGraph()
edges = [
    (0,3,"+1.0"), (1,3,"-1.0"), (2,3,"-0.5"),
    (0,4,"-1.0"), (1,4,"+1.0"), (2,4,"-0.5"),
    (3,7,"+1.0"), (4,7,"+1.0")
]
G.add_edges_from([(u,v,{"label":lbl}) for u,v,lbl in edges])

pos = {0:(0,1),1:(0,-1),2:(0,0),
       3:(1,1),4:(1,-1),
       7:(2,0)}
nx.draw(G,pos,with_labels=True,node_size=1200,node_color="lightblue")
nx.draw_networkx_edge_labels(G,pos,edge_labels={(u,v):d["label"] for u,v,d in G.edges(data=True)})
plt.savefig("xor_snn.png", dpi=300, bbox_inches="tight")
plt.show()
