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
	; (focus move-willy)
	(return)
)
;=========================================
(defmodule move-willy (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule move-willy::moveWilly
	(declare (salience 1))
	(movimientos ?x&:(< ?x 855))
  	(directions $? ?direction $?)
=>
  	(moveWilly ?direction)
	(assert(direccion ?direction))
	(focus contabilizador-movimientos)
)

(defrule move-willy::WillyNorth
	(declare (salience 2))
	(movimientos ?moves&:(< ?moves 855))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (anterior ?)
	?h3 <- (direccion north)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(posicion-willy ?x (+ ?y 1)))
	(assert(visitados (x ?x) (y (+ ?y 1))))
	(assert(anterior south))
	(focus peligros)
)


(defrule move-willy::WillySouth
	(declare (salience 2))
	(movimientos ?moves&:(< ?moves 855))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (anterior ?)
	?h3 <- (direccion south)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(posicion-willy ?x (- ?y 1)))
	(assert(visitados (x ?x) (y (- ?y 1))))
	(assert(anterior north))
	(focus peligros)
)


(defrule move-willy::WillyEast
	(declare (salience 2))
	(movimientos ?moves&:(< ?moves 855))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (anterior ?)
	?h3 <- (direccion east)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(posicion-willy (+ ?x 1) ?y))
	(assert(visitados (x (+ ?x 1)) (y ?y)))
	(assert(anterior west))
	(focus peligros)
)


(defrule move-willy::WillyWest
	(declare (salience 2))
	(movimientos ?moves&:(< ?moves 855))
	?h1 <- (posicion-willy ?x ?y)
	?h2 <- (anterior ?)
	?h3 <- (direccion west)
=>
	(retract ?h1)
	(retract ?h2)
	(retract ?h3)
	(assert(posicion-willy (- ?x 1) ?y))
	(assert(visitados (x (- ?x 1)) (y ?y)))
	(assert(anterior east))
	(focus peligros)
)

(defmodule peligros (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
(defrule peligros::evitar-peligros-norte
	(declare(salience 1))
	(or (percepts Noise) (percepts Pull) (percepts Noise Pull) (percepts Pull Noise))
	(movimientos ?y&:(< ?y 855))
	(anterior south)
	?h1 <- (posicion-willy ?x1 ?x2)
=>
	(assert(dispara north))
	(focus disparar-alien)
	(moveWilly south)
	(retract ?h1)
	(assert(posicion-willy ?x1 (- ?x2 1)))
	(assert(visitados (x ?x1) (y (- ?x2 1))))
	(focus contabilizador-movimientos)
	(return)
)

(defrule peligros::evitar-peligros-sur
	(declare(salience 1))
	(or (percepts Noise) (percepts Pull) (percepts Noise Pull) (percepts Pull Noise))
	(movimientos ?y&:(< ?y 855))
	(anterior north)
	?h1 <- (posicion-willy ?x1 ?x2)
=>
	(assert(dispara south))
	(focus disparar-alien)
	(moveWilly north)
	(retract ?h1)
	(assert(posicion-willy ?x1 (+ ?x2 1)))
	(assert(visitados (x ?x1) (y (+ ?x2 1))))
	(focus contabilizador-movimientos)
	(return)
)

(defrule peligros::evitar-peligros-este
	(declare(salience 1))
	(or (percepts Noise) (percepts Pull) (percepts Noise Pull) (percepts Pull Noise))
	(movimientos ?y&:(< ?y 855))
	(anterior west)
	?h1 <- (posicion-willy ?x1 ?x2)
=>
	(assert(dispara east))
	(focus disparar-alien)
	(moveWilly west)
	(retract ?h1)
	(assert(posicion-willy (- ?x1 1) ?x2))
	(assert(visitados (x (- ?x1 1)) (y ?x2)))
	(focus contabilizador-movimientos)
	(return)
)

(defrule peligros::evitar-peligros-oeste
	(declare(salience 1))
	(or (percepts Noise) (percepts Pull) (percepts Noise Pull) (percepts Pull Noise))
	(movimientos ?y&:(< ?y 855))
	(anterior east)
	?h1 <- (posicion-willy ?x1 ?x2)
=>
	(assert(dispara west))
	(focus disparar-alien)
	(moveWilly east)
	(retract ?h1)
	(assert(posicion-willy (+ ?x1 1) ?x2))
	(assert(visitados (x (+ ?x1 1)) (y ?x2)))
	(focus contabilizador-movimientos)
	(return)
)

(defrule peligros::localizacion-posible-alien
	(declare(salience 3))
	(percepts $? Noise $?)
	(posicion-willy ?x ?y)
=>
	(assert(posible-alien (x ?x) (y ?y)))
	(assert(es-alien))
)

(defrule peligros::hay-alien ;El menor de las diferencias puede dividir al resto de las diferencias :). Hazlo daniel
	(declare(salience 2))
	?h1 <- (posible-alien (x ?x) (y ?y))
	?h2 <- (posible-alien (x ?x1) (y ?y1))
	?h3 <- (posible-alien (x ?x2) (y ?y2))
	?h4 <- (posible-alien (x ?x3) (y ?y3))
	(test(= (abs(- ?x ?y))
		(abs(- ?x1 ?y1))
		(abs(- ?x2 ?y2))
		(abs(- ?x3 ?y3))

	))
	(test (= ?y ?y1))
	(test (neq ?h1 ?h2 ?h3 ?h4))
=>
	(assert(alien-seguro (x (div (+ ?x ?x1) 2))  (y (div (+ ?y ?y1) 2)) ))
)

(defmodule disparar-alien (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (import peligros ?ALL) (export ?ALL))
(defrule disparar-alien::disparar-a-willy
	(declare(salience 2))
	(hasLaser)
	; (directions $? ?direction $?)
	?h1 <- (dispara ?a)
	?h2 <- (es-alien)
=>
	(fireLaser ?a)
	(retract ?h1)
	(retract ?h2)
	(return)
)

(defrule disparar-alien::borrarDireccionDisparo
	(declare(salience 1))
	?h1 <- (dispara ?direction)
=>
	(retract ?h1)
)
; (defmodule calculo-posicion-willy (import InternalFunctions deffunction ?ALL) (import myMAIN deftemplate ?ALL) (export ?ALL))
; (defrule calculo-posicion-willy::posicion-north
; 	?h1 <- (direccion north)
; 	; (directions north $?)
; 	?h2 <- (posicion-willy ?x ?y)
; =>
; 	(retract ?h1)
; 	(retract ?h2)
; 	(assert(posicion-willy ?x (+ ?y 1)))
; 	(focus move-willy)
; 	; (return)
; )
;
; (defrule calculo-posicion-willy::posicion-south
; 	?h1 <- (direccion south)
; 	; (directions south $?)
; 	?h2 <- (posicion-willy ?x ?y)
; =>
; 	(retract ?h1)
; 	(retract ?h2)
; 	(assert(posicion-willy ?x (- ?y 1)))
; 	(focus move-willy)
; 	; (return)
; )
;
; (defrule calculo-posicion-willy::posicion-east
; 	?h1 <- (direccion east)
; 	; (directions east $?)
; 	?h2 <- (posicion-willy ?x ?y)
; 	=>
; 	(retract ?h1)
; 	(retract ?h2)
; 	(assert(posicion-willy (+ ?x 1) ?y))
; 	(focus move-willy)
; 	; (return)
; )
;
; (defrule calculo-posicion-willy::posicion-west
; 	?h1 <- (direccion west)
; 	; (directions west $?)
; 	?h2 <- (posicion-willy ?x ?y)
; 	=>
; 	(retract ?h1)
; 	(retract ?h2)
; 	(assert(posicion-willy (- ?x 1) ?y))
; 	(focus move-willy)
; 	; (return)
; )
