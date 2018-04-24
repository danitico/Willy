(deffacts f1
	(posicion-willy 0 0)
   (visitados (x 0) (y 0))
)
(deftemplate visitados
	(slot x)
	(slot y)
)
(deftemplate casilla-segura
	(slot x)
	(slot y)
)
(deftemplate posible-alien
	(slot x)
	(slot y)
)
(deftemplate posible-agujero
	(slot x)
	(slot y)
)



(defrule moveWilly
   (directions $? ?direction $?)
   =>
   (moveWilly ?direction)
	(assert(direccion ?direction))
)

(defrule fireWilly
	(hasLaser)
	(directions $? ?direction $?)
	=>
	(fireLaser ?direction)
)



(defrule esSeguro
	(declare (salience 99))
	(posicion-willy ?x ?y)
	(percepts)
	(directions ?a ?b ?c ?d)
=>
	(assert(casilla-segura (x (- ?x 1)) (y ?y)))
	(assert(casilla-segura (x (+ ?x 1)) (y ?y)))
	(assert(casilla-segura (x ?x) (y (- ?y 1))))
	(assert(casilla-segura (x ?x) (y (+ ?y 1))))
)


(defrule esSeguroEsquinaSuperiorIzquierda
	(declare (salience 99))
	(posicion-willy ?x ?y)
	(percepts)
	(or (directions east south) (directions south east))
=>
	(assert(casilla-segura (x (+ ?x 1)) (y ?y)))
	(assert(casilla-segura (x ?x) (y (- ?y 1))))
)


(defrule esSeguroEsquinaInferiorIzquierda
	(declare (salience 99))
	(posicion-willy ?x ?y)
	(percepts)
	(or (directions east north) (directions north east))
=>
	(assert(casilla-segura (x (+ ?x 1)) (y ?y)))
	(assert(casilla-segura (x ?x) (y (+ ?y 1))))
)


(defrule esSeguroEsquinaSuperiorDerecha
	(declare (salience 99))
	(posicion-willy ?x ?y)
	(percepts)
	(or (directions west south) (directions south west))
=>
	(assert(casilla-segura (x (- ?x 1)) (y ?y)))
	(assert(casilla-segura (x ?x) (y (- ?y 1))))
)


(defrule esSeguroEsquinaInferiorDerecha
	(declare (salience 99))
	(posicion-willy ?x ?y)
	(percepts)
	(or (directions west north) (directions north west))
=>
	(assert(casilla-segura (x (- ?x 1)) (y ?y)))
	(assert(casilla-segura (x ?x) (y (+ ?y 1))))
)



(defrule WillyNorth
	(declare (salience 99))
;	(visitados (x ?x) (y ?y&:(+ ?y 1)))
	?h2 <- (direccion north)
	?h1 <- (posicion-willy ?x ?y)
=>
	(retract ?h1)
	(retract ?h2)
	(assert(posicion-willy ?x (+ ?y 1)))
	(assert(visitados (x ?x) (y (+ ?y 1))))
)


(defrule WillySouth
	(declare (salience 99))
;	(visitados (x ?x) (y ?y&:(- ?y 1)))
	?h2 <- (direccion south)
	?h1 <- (posicion-willy ?x ?y)
=>
	(retract ?h1)
	(retract ?h2)
	(assert(posicion-willy ?x (- ?y 1)))
   (assert(visitados (x ?x) (y (- ?y 1))))
)


(defrule WillyEast
	(declare (salience 99))
;	(visitados (x ?x&:(+ ?x 1)) (y ?y))
	?h2 <- (direccion east)
	?h1 <- (posicion-willy ?x ?y)
=>
	(retract ?h1)
	(retract ?h2)
	(assert(posicion-willy (+ ?x 1) ?y))
   (assert(visitados (x (+ ?x 1)) (y ?y)))
)


(defrule WillyWest
	(declare (salience 99))
;   (visitados (x ?x&:(- ?x 1)) (y ?y))
	?h2 <- (direccion west)
	?h1 <- (posicion-willy ?x ?y)
=>
	(retract ?h1)
	(retract ?h2)
	(assert(posicion-willy (- ?x 1) ?y))
   (assert(visitados (x (- ?x 1)) (y ?y)))
)
