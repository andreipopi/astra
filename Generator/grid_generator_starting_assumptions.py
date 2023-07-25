from cmath import pi
import random
import sys
from collections import Counter
import os

assumptions = []
atoms = []
contraries = []
grid = []
rules =[]

def initialise(n_assumptions, n_total_sentences):
    assumptions = ["a" + str(i) for i in range(n_assumptions)]
    atoms = ["s" + str(i) for i in range(n_total_sentences-n_assumptions)]
    #contraries = {asmpt: random.choice(atoms+assumptions) for asmpt in assumptions}
    print(" Initial assumptions: ",assumptions)
    print("Initial atoms: ", atoms)
    return assumptions, atoms, contraries
 
def neighbourhood_deep(i,j,n,k):
    neigh = []
    if i == 0: 
        if j == 0: #first row left
            if i+2 <=n:
                neigh = [grid[i+2][j]]
            if j+2 <=k:
                neigh.append(grid[i][j+2])
        else:
            if j == k: #first row right
                if i+2 <=n:
                    neigh = [grid[i+2][j]]
                if j-2 >=0:
                    neigh.append(grid[i][j-2])
            else: #first row middle
                if i+2 <=n:
                    neigh = [grid[i+2][j]]
                if j+2 <=k:
                    neigh.append(grid[i][j+2])
                if j-2 >=0:
                    neigh.append(grid[i][j-2])
    else:
        if i == n:
            if j == 0: #last row left
                if i-2 >=0:
                    neigh = [grid[i-2][j]]
                if j+2 <=k:
                    neigh.append(grid[i][j+2])
            else:
                if j == k: #last row right
                    if i-2 >=0:
                        neigh = [grid[i-2][j]]
                    if j-2 >=0:
                        neigh.append(grid[i][j-2])
                else: #last row middle
                    if i-2 >=0:
                        neigh = [grid[i-2][j]]
                    if j-2 >=0:
                        neigh.append(grid[i][j-2])
                    if j+2 <=k:
                        neigh.append(grid[i][j+2])
        else: #middle rows
            if j == 0: #middle row left
                    if j+2 <=k:
                        neigh = [grid[i][j+2]]
                    if i-2 >=0:
                        neigh.append(grid[i-2][j])
                    if i+2 <=n:
                        neigh.append(grid[i+2][j])
            else:
                if j == k: #middle row right
                    if i+2 <=n:
                        neigh = [grid[i+2][j]]
                    if i-2 >=0:
                        neigh.append(grid[i-2][j])
                    if j-2 >=0:
                        neigh.append(grid[i][j-2])
                else:
                    #middle row middle
                    if i+2 <=n:
                        neigh = [grid[i+2][j]]
                    if i-2 >=0:
                        neigh.append(grid[i-2][j])

                    if j-2 >=0:
                        neigh.append(grid[i][j-2])
                    if j+2 <=k:
                        neigh.append(grid[i][j+2])
    return neigh

def neighbourhood(i,j,n,k):
    neigh = []
    if i == 0: 
        if j == 0: #first row left
            neigh = [grid[i+1][j], grid[i][j+1]]
        else:
            if j == k: #first row right
                neigh = [grid[i+1][j], grid[i][j-1]]
            else: #first row middle
                neigh = [grid[i+1][j], grid[i][j+1], grid[i][j-1]]
    else:
        if i == n:
            if j == 0: #last row left
                neigh = [grid[i-1][j], grid[i][j+1]]
            else:
                if j == k: #last row right
                    neigh = [grid[i-1][j], grid[i][j-1]]
                else: #last row middle
                    neigh = [grid[i-1][j], grid[i][j+1], grid[i][j-1]]
        else: #middle rows
            if j == 0: #middle row left
                neigh = [grid[i-1][j], grid[i+1][j], grid[i][j+1]]
            else:
                if j == k: #middle row right
                    neigh = [grid[i-1][j], grid[i+1][j], grid[i][j-1]]
                else:
                    #middle row middle
                    neigh = [grid[i-1][j], grid[i+1][j], grid[i][j-1], grid[i][j+1]]
    return neigh

def create_grid(k,n):
    grid_content = assumptions.copy()
    grid_content.extend(atoms)
    random.shuffle(grid_content)
    index = 0
    for _ in range(0, n):
        row = []
        for _ in range(0, k):
            row.append(grid_content[index])
            index = index + 1
        grid.append(row)
    print_grid(grid)
    return grid

def print_grid(grid):
    for row in grid:
        print(row,"\n")
    return

def create_framework(n, k):
    # for each head create a random number(fixed for all heads) picked in range(1,3) of rules with that head.
    n_rph = random.sample(range(1, 4),1) #this creates 1, 2, or 3 rules
    # number of rules to be created is fixed for all atoms
    # 
    for l in range(0, n_rph[0]):
        print("i: ",l)
        for i in range(0, n):
            for j in range(0, k):

                if "s" in grid[i][j]: #only non-assumption atoms can be heads
                    head = grid[i][j]
                    selection_set = neighbourhood(i,j,n-1,k-1) #indexes go to n-1 and k-1, depth=0 means we look in the immediate neighbourhood
                    print(grid[i][j],": ", "selection set:" ,selection_set  )
                   
                    toRemove = []
                    if l==0: #in the first iteration only allow assumptions in the selection set.
                        for elem in selection_set:
                            if 's' in elem:
                                toRemove.append(elem)

                    selection_set = list(set(selection_set)- set(toRemove))
                    print(grid[i][j],": ", "selection set:" ,selection_set  )

                    n_body = random.sample(list(range(0, len(selection_set)+1)),1) #select [0 - len(neighbours)] body elements for the rule currently being built
                    body = []

                    print()

                    for _ in range(n_body[0]):
                        body.extend(random.sample(selection_set,1))

                    rules.append((head, body))

                else:
                    # build contraries for assumptions, based on a coin flip.
                    if "a" in grid[i][j]:
                        selection_set = neighbourhood_deep(i,j,n-1,k-1) #indexes go to n-1 and k-1
                        #print(grid[i][j],": ", "selection set for contrary:" ,selection_set  )
                        flip = random.randint(0, 1)
                        if flip == 1:
                            #print("random contrary picked", random.sample(selection_set,1))

                            if grid[i][j] not in [tpl[0] for tpl in contraries]:
                                contraries.append((grid[i][j], random.sample(selection_set,1)[0]))
        query = random.sample(list(set(assumptions) | set(atoms)),1)[0] 
                    
    return assumptions, atoms, contraries, rules, query

def print_ASP(assumptions, atoms, contraries, rules, query, out_filename):
    """
    Print the given framework in ASP format.
    """

    if not os.path.exists(os.path.dirname("instances/")):
        os.makedirs(os.path.dirname("instances/"))

    with open("instances/"+out_filename, 'w') as out:
        for asm in assumptions:
            out.write("assumption(" + asm + ").\n")
        for atm in atoms:
            out.write("atom(" + atm + ").\n")
        for ctr in contraries:
            #print("ctr", ctr)
            out.write("contrary("+ ctr[0]+","+ctr[1]+").\n")
            #out.write("contrary(" + ctr + "," + contraries.get(ctr) + ").\n") #original writing of contraries
        for i in range(0,len(rules)):
            out.write("rule("+str(i)+").\n")
        for i, rule in enumerate(rules):
            out.write("head(" + str(i) + "," + rule[0] + ").\n")
            if rule[1]:
                for body in rule[1]:
                    out.write("body(" + str(i) + "," + body + ").\n")
        
        out.write("query(" + str(query) + ").")

# INPUT
k = int(sys.argv[1])
n = int(sys.argv[2])

id_instance = int(sys.argv[3])

n_total_sentences = k * n # total number of sentences in the language
n_assumptions = int(round(0.3*n_total_sentences)) # a percentage of those will be assumptions
print("nsentences: ", n_total_sentences, " nassumptions: ", n_assumptions)

assumptions, atoms, contraries = initialise(n_assumptions, n_total_sentences)

create_grid(k,n)

framework = create_framework(n, k)

# create the instance in the instances folder with name k_X_n_Y_ID.py 
print_ASP(framework[0], framework[1], framework[2], framework[3], framework[4], "k"+str(k)+"_"+"n"+str(n)+"_q"+str(framework[4])+"_"+str(id_instance)+".txt")

# foreach rule being created, a random number of sentences in the body will be established from this range.
#n_spb = range(1, 5)

#print(contraries)
for rule in  rules:
	print(rule,"\n")