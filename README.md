# SAT
SAT solver -> uses the DPLL algorithm.

Not the most efficient one...

input/output -> ?- sat(p1*(-p1+ -p2)*(p3+p2)*(-p7+p2)*(-p3+p4)*(-p3+p5)*(-p4+ -p+q)*(-p5+ -p6+r)*(-p+ -q+p6)*(p+p7)*(-r+p7),A).
                A = []
                ?- sat((-p+ -q)*(-p+q)*(p+ -q)*(p+q),A).
                A = []
                ?- sat(p1*(-p1+ -p2)*(-r+p7)*(r+s),A).
                A = [[p1-t,p7-t,r-t,-p2-t],[p1-t,p7-t,s-t,-p2-t],[p1-t,s-t,-p2-t,-r-t]]
                ?- sat((p+q+r)*(-p+ -q+ -r)*(p+ -q+ -rp+q+ -r)*(-p+q)*(-p+r)*(p+ -q+r),A).
                A = [[q-t,r-t,-p-t],[q-t,r-t,-p-t,-rp-t],[r-t,-p-t,-q-t]]
