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
(deffacts f1
	(posicion-willy 0 0)
   (visitados (x 0) (y 0))
	(anterior nada)
	(movimientos 1)
)


(defrule moveWilly
	(declare (salience 97))
	(not(parar))
   (directions $? ?direction $?)
	?h1 <- (movimientos ?x)
   =>
	(retract ?h1)
	(assert(movimientos (+ ?x 1)))
   (moveWilly ?direction)
	(assert(direccion ?direction))
)

(defrule fireWilly
	(hasLaser)
	(directions $? ?direction $?)
	=>
	(fireLaser ?direction)
)

;(defrule RiesgosReales
;	?h1 <- (posible-alien (x ?x) (y ?y))
;	?h2 <- (posible-agujero (x ?z&:(= ?x ?z)) (y ?u&:(= ?y ?u)))
;=>
;	(assert(riesgo-seguro (x ?x) (y ?y)))
;	(retract ?h1)
;	(retract ?h2)
;)
;(defrule alien
;	(percepts Noise)
;	(posicion-willy ?x ?y)
;=>


(defrule esSeguroVisitados
	(declare (salience 99))
	(visitados (x ?x) (y ?y))
	(not(casilla-segura (x ?x1&:(= ?x1 ?x)) (y ?y1&:(= ?y1 ?y))))
=>
	(assert(casilla-segura (x ?x) (y ?y)))
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


;(defrule LimiteSuperior
;	(declare (salience 99))
;	(posicion-willy ?x ?y)
;	(percepts)

;=>
;	(assert(casilla-segura (x (- ?x 1)) (y ?y)))
;	(assert(casilla-segura (x ?x) (y (+ ?y 1))))
;)



(defrule WillyNorth
	(declare (salience 99))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion north)
	?h3 <- (anterior ?)
;	(visitados (x ?z) (y ?u&:(+ ?y 1)))
;	(percepts)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior south))
	(assert(posicion-willy ?x (+ ?y 1)))
	(assert(visitados (x ?x) (y (+ ?y 1))))
)


(defrule WillySouth
	(declare (salience 99))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion south)
	?h3 <- (anterior ?)
;	(not(visitados (x ?z) (y ?u&:(- ?y 1))))
;	(percepts)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior north))
	(assert(posicion-willy ?x (- ?y 1)))
   (assert(visitados (x ?x) (y (- ?y 1))))
)


(defrule WillyEast
	(declare (salience 99))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion east)
	?h3 <- (anterior ?)
;	(not(visitados (x ?z&:(+ ?x 1)) (y ?u)))
;	(percepts)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior west))
	(assert(posicion-willy (+ ?x 1) ?y))
   (assert(visitados (x (+ ?x 1)) (y ?y)))
)


(defrule WillyWest
	(declare (salience 99))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion west)
	?h3 <- (anterior ?)
;	(not(visitados (x ?z&:(- ?x 1)) (y ?u)))
;	(percepts)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior east))
	(assert(posicion-willy (- ?x 1) ?y))
   (assert(visitados (x (- ?x 1)) (y ?y)))
)

(defrule evitar-peligro
	(declare (salience 98))
	(or (percepts Noise) (percepts Pull) (percepts Noise Pull) (percepts Pull Noise))
	?h1 <- (movimientos ?y)
	?h2 <- (anterior ?x)
=>
	(moveWilly ?x)
	(retract ?h1)
	;(retract ?h2)
	(assert(movimientos (+ ?y 1)))
)



(defrule quitarpeligro-alien
	(visitados (x ?x) (y ?y))
	?h1 <- (posible-alien (x ?x1&:(= ?x1 ?x)) (y ?y1&:(= ?y1 ?y)))
=>
	(retract ?h1)
)

(defrule stop-willy
	(declare (salience 100))
	(movimientos 999)
=>
	(assert(parar))
)
