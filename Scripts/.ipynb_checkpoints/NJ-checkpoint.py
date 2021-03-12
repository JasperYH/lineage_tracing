import numpy as np

class treeNode(object):
    def __init__(self,name=None):
        self.name = name
        self.left = None
        self.right = None
        self.dist = 0
        
class NJ(object):
    def __init__(self):
        pass
    
    def merge_node(self,D):
        s = np.sum(D,axis=0)
        n = len(D)
        Q = (D*(n-2)-s).T-s
        Q[np.arange(n),[np.arange(n)]] = 0
        
        min_dist = float('inf')
        n = Q.shape[0]
        for i in range(n):
            for j in range(n):
                if i != j and Q[i,j]<min_dist:
                    node = (i,j)
                    min_dist = Q[i,j]
        return node

    def update_dist_table(self,X,i,j):
        a = X[i]
        b = X[j]
        index = [a for a in range(len(X)) if a!=i and a!=j]
        dist = [0]
        for n in index:
            dist.append((X[i,n]+X[j,n]-X[i,j])/2)
        X = X[index][:,index]
        X_out = np.zeros((len(X)+1,len(X)+1),dtype='float')
        X_out[0] = dist
        X_out[:,0] = dist
        X_out[1:,1:] = X
        return X_out
    
    def neighbor_joining(self,D,names):
        self.n = len(D)
        self.tree_nodes = [treeNode(name=names[i]) for i in range(self.n)]
        self.paths = []
        clusters = [i for i in range(self.n)]
        
        for c in range(self.n-1):
            n = len(D)
            s = np.sum(D,axis=0)
            i,j = self.merge_node(D)
            self.paths.append((clusters[i],clusters[j]))
            parent = treeNode()
            if n > 2:
                self.tree_nodes[clusters[i]].dist = D[i,j]/2+(s[i]-s[j])/(2*(n-2))
                self.tree_nodes[clusters[j]].dist = D[i,j]/2+(s[j]-s[i])/(2*(n-2))
            elif n == 2:
                self.tree_nodes[clusters[i]].dist = D[0,1]
                self.tree_nodes[clusters[j]].dist = D[0,1]
                
            parent.left = self.tree_nodes[clusters[i]]
            parent.right = self.tree_nodes[clusters[j]]
            self.tree_nodes.append(parent)
        
            clusters = [self.n+c]+[clusters[a] for a in range(n) if a!=i and a!=j]
            D = self.update_dist_table(D,i,j)
        self.root = self.tree_nodes[-1]

def write_newick(root):
    def helper(root):
        if not root:
            return
        
        if not root.left and not root.right:
            return "%s:%f" % (root.name,root.dist)
        
        return "(%s,%s)" % (helper(root.left),helper(root.right))
        
    return helper(root) + ";"