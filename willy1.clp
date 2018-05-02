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
;(defmodule controlador-willy (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
;(defrule controlador-willy::stop-willy
;	(movimientos 100)
;=>
;	(assert(parar))
	;(focus move-willy)
	;(return)
;)
(defmodule move-willy (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule move-willy::moveWilly
	(declare (salience 1))
	(movimientos ?x&:(< ?x 998))
   (directions $? ?direction $?)
=>
   (moveWilly ?direction)
	(assert(direccion ?direction))
	(focus contabilizador-movimientos)
	;(focus controlador-willy)
)


(defrule move-willy::WillyNorth
	(declare (salience 2))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion north)
	?h3 <- (anterior ?)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior south))
	(assert(posicion-willy ?x (+ ?y 1)))
	(assert(visitados (x ?x) (y (+ ?y 1))))
	(focus peligros)
)


(defrule move-willy::WillySouth
	(declare (salience 2))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion south)
	?h3 <- (anterior ?)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior north))
	(assert(posicion-willy ?x (- ?y 1)))
   (assert(visitados (x ?x) (y (- ?y 1))))
	(focus peligros)
)


(defrule move-willy::WillyEast
	(declare (salience 2))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion east)
	?h3 <- (anterior ?)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior west))
	(assert(posicion-willy (+ ?x 1) ?y))
   (assert(visitados (x (+ ?x 1)) (y ?y)))
	(focus peligros)
)


(defrule move-willy::WillyWest
	(declare (salience 2))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (direccion west)
	?h3 <- (anterior ?)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(anterior east))
	(assert(posicion-willy (- ?x 1) ?y))
   (assert(visitados (x (- ?x 1)) (y ?y)))
	(focus peligros)
)

(defmodule peligros (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule peligros::evitar-peligros
	(or (percepts Noise) (percepts Pull) (percepts Noise Pull) (percepts Pull Noise))
	(movimientos ?y&:(< ?y 998))
	(anterior ?x)
=>
	(moveWilly ?x)
	(focus contabilizador-movimientos)
	(return)
)
