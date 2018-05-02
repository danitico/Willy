;*****************************************
; Autores:
; Historial de cambios:
;  - Fecha: mejoras/cambios
;*****************************************

(defrule MAIN::passToMyMAIN
	=>
	(focus myMAIN))


;==========================================
(defmodule myMAIN (import MAIN deftemplate ?ALL) (import InternalFunctions deffunction ?ALL) (export deftemplate ?ALL))
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
(deftemplate alien-seguro
	(slot x)
	(slot y)
)
(deffacts f1
	(posicion-willy 0 0)
   (visitados (x 0) (y 0))
	(anterior nada)
	(movimientos 0)
)

(defrule myMAIN::iniciador
	(declare (salience 100))
=>
	(focus move-willy)
)
;=====================================
(defmodule contabilizador-movimientos (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule contabilizador-movimientos::contador
	?h1 <- (movimientos ?x)
=>
	(retract ?h1)
	(assert(movimientos (+ ?x 1)))
	;(focus move-willy)
	(return)
)
;=========================================
(defmodule move-willy (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule move-willy::moveWilly
	(declare (salience 1))
	(movimientos ?x&:(< ?x 998))
   (directions $? ?direction $?)
=>
   (moveWilly ?direction)
	(assert(direccion ?direction))
	(focus contabilizador-movimientos)
)


(defrule move-willy::WillyNorth
	(declare (salience 2))
	(posicion-willy ?x ?y)
	?h1 <- (direccion north)
	?h2 <- (anterior ?)
=>
	(focus calculo-posicion-willy)
	(retract ?h1)
	(retract ?h2)
	(assert(anterior south))
	(assert(visitados (x ?x) (y (+ ?y 1))))
	(focus peligros)
)


(defrule move-willy::WillySouth
	(declare (salience 2))
	(posicion-willy ?x ?y)
	?h1 <- (direccion south)
	?h2 <- (anterior ?)
=>
	(focus calculo-posicion-willy)
	(retract ?h1)
	(retract ?h2)
	(assert(anterior north))
   (assert(visitados (x ?x) (y (- ?y 1))))
	(focus peligros)
)


(defrule move-willy::WillyEast
	(declare (salience 2))
	(posicion-willy ?x ?y)
	?h1 <- (direccion east)
	?h2 <- (anterior ?)
=>
	(focus calculo-posicion-willy)
	(retract ?h1)
	(retract ?h2)
	(assert(anterior west))
	(assert(visitados (x (+ ?x 1)) (y ?y)))
	(focus peligros)
)


(defrule move-willy::WillyWest
	(declare (salience 2))
	(posicion-willy ?x ?y)
	?h1 <- (direccion west)
	?h2 <- (anterior ?)
=>
	(focus calculo-posicion-willy)
	(retract ?h1)
	(retract ?h2)
	(assert(anterior east))
   (assert(visitados (x (- ?x 1)) (y ?y)))
	(focus peligros)
)

(defmodule peligros (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule peligros::evitar-peligros
	(or (percepts Noise) (percepts Pull) (percepts Noise Pull) (percepts Pull Noise))
	(movimientos ?y&:(< ?y 998))
	(anterior ?x)
=>
	(focus disparar-alien)
	(moveWilly ?x)
	(focus contabilizador-movimientos)
	(return)
)

(defrule peligros::localizacion-posible-alien
	(percepts $? Noise $?)
	(posicion-willy ?x ?y)
=>
	(assert(posible-alien (x ?x) (y ?y)))
)

;(defrule peligros::hay-alien
;	?h1 <- (posible-alien (x ?x) (y ?y))
;	?h2 <- (posible-alien (x ?x1) (y ?y1))
;	?h3 <- (posible-alien (x ?x2) (y ?y2))
;	?h4 <- (posible-alien (x ?x3) (y ?y3))
;	(test(= (abs(- ?x ?y))
		;(abs(- ?x1 ?y1))
		;(abs(- ?x2 ?y2))
		;(abs(- ?x3 ?y3))

	;))
	;(test (= ?y ?y1))
	;(test (neq ?h1 ?h2 ?h3 ?h4))
;=>
	;(assert(alien-seguro (x (div (+ ?x ?x1) 2))  (y (div (+ ?y ?y1) 2)) ))
;)

(defmodule disparar-alien (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule disparar-alien::fireWilly
	(hasLaser)
	(directions $? ?direction $?)
	(or (percepts Noise) (percepts Noise Pull) (percepts Pull Noise))
	=>
	(fireLaser ?direction)
	(return)
)
(defmodule calculo-posicion-willy (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule calculo-posicion-willy::posicion-north
	(direccion north)
	?h1 <- (posicion-willy ?x ?y)
=>
	;(retract ?h1)
	(assert(posicion-willy ?x (+ ?y 1)))
	(return)
)

(defrule calculo-posicion-willy::posicion-south
	(direccion south)
	?h1 <- (posicion-willy ?x ?y)
=>
	;(retract ?h1)
	(assert(posicion-willy ?x (- ?y 1)))
	(return)
)

(defrule calculo-posicion-willy::posicion-east
	(direccion east)
	?h1 <- (posicion-willy ?x ?y)
	=>
	;(retract ?h1)
	(assert(posicion-willy (+ ?x 1) ?y))
	(return)
)

(defrule calculo-posicion-willy::posicion-west
	(direccion west)
	?h1 <- (posicion-willy ?x ?y)
	=>
	;(retract ?h1)
	(assert(posicion-willy (- ?x 1) ?y))
	(return)
)
