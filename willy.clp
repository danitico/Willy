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
(defrule esSeguro
	(declare (salience 99))
	(posicion-willy ?x ?y)
	(not(percepts Noise Pull))
	(not(percepts Pull Noise))
	(directions ?a ?b ?c ?d)
=>
	(assert(casilla-segura (x (- ?x 1)) (y ?y)))
	(assert(casilla-segura (x (+ ?x 1)) (y ?y)))
	(assert(casilla-segura (x ?x) (y (- ?y 1))))
	(assert(casilla-segura (x ?x) (y (+ ?y 1))))
)
(deffacts f1
	(posicion-willy 0 0)
)
(defrule WillyNorth
	(declare (salience 99))
	(not(visitados (x ?x) (y ?y&:(+ ?y 1))))
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
   (not(visitados (x ?x) (y ?y&:(- ?y 1))))
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
   (not(visitados (x ?x&:(+ ?x 1)) (y ?y)))
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
   (not(visitados (x ?x&:(- ?x 1)) (y ?y)))
	?h2 <- (direccion west)
	?h1 <- (posicion-willy ?x ?y)
=>
	(retract ?h1)
	(retract ?h2)
	(assert(posicion-willy (- ?x 1) ?y))
   (assert(visitados (x (- ?x 1)) (y ?y)))
)
(defrule borrarHecho
   (declare (salience 98))
   ?h1 <- (direccion ?a)
=>
   (retract ?h1)
)
