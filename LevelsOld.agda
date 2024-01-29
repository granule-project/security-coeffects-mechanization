{-# OPTIONS --allow-unsolved-metas #-}

module Levels where

open import Relation.Binary.PropositionalEquality
open import Relation.Nullary
open import Relation.Unary
open import Data.Empty
open import Semiring

open Semiring.Semiring
open Semiring.NonInterferingSemiring
open Semiring.InformationFlowSemiring

open import Data.Maybe
open import Data.Maybe.Properties

-- # Level semiring definition

-- Level elements
data Level : Set where
  Public  : Level
  Private : Level
  Dunno   : Level
  Unused  : Level

-- constructive representation of the ordering (using Granule ordering)
data Order : Level -> Level -> Set where
  -- central 'line' and its transitivity
  0Pub    : Order Unused Public
  0Priv   : Order Unused Private
  PrivPub : Order Private Public
  -- dunno branch
  0Dunno  : Order Unused Dunno
  PrivDunno : Order Private Dunno
  DunnoPub  : Order Dunno Public
  -- reflexive cases
  Refl : (l : Level) -> Order l l

-- reify the indexed type ordering
reified : (l : Level) -> (j : Level) -> Dec (Order j l)
reified Public Public   = yes (Refl Public)
reified Public Private  = yes PrivPub
reified Public Dunno    = yes DunnoPub
reified Public Unused   = yes 0Pub
reified Private Public  = no (λ ())
reified Private Private = yes (Refl Private)
reified Private Dunno   = no (λ ())
reified Private Unused  = yes 0Priv
reified Dunno Public    = no (λ ())
reified Dunno Private   = yes PrivDunno
reified Dunno Dunno     = yes (Refl Dunno)
reified Dunno Unused    = yes 0Dunno
reified Unused Public   = no (λ ())
reified Unused Private  = no (λ ())
reified Unused Dunno    = no (λ ())
reified Unused Unused   = yes (Refl Unused)

instance
  levelSemiring : Semiring
  grade levelSemiring = Level
  1R levelSemiring      = Private
  0R levelSemiring      = Unused

  -- remember the ordering in the calculus goes the 'opposite way' to Granule but
  -- the above `Order` data type is defined using Granule's direction
  -- *so we need to flip here*
  _≤_ levelSemiring x y = Order y x

  _≤d_ levelSemiring = reified

  -- unit property
  _+R_ levelSemiring Unused x = x
  _+R_ levelSemiring x Unused = x
  -- Hack for Private
  _+R_ levelSemiring Dunno Private = Dunno
  _+R_ levelSemiring Private Dunno = Dunno
 -- otherwise dunno acts like another unit
  _+R_ levelSemiring Dunno x = x
  _+R_ levelSemiring x Dunno = x
  -- otherwise join
  _+R_ levelSemiring Private Private = Private
  _+R_ levelSemiring Public  Public  = Public
  _+R_ levelSemiring Private Public  = Public
  _+R_ levelSemiring Public Private  = Public

  -- absorbing
  _*R_ levelSemiring Unused x = Unused
  _*R_ levelSemiring x Unused = Unused
  -- dunno behaviour
  _*R_ levelSemiring Private Dunno = Dunno
  _*R_ levelSemiring Dunno Private = Dunno
  _*R_ levelSemiring x Dunno = x
  _*R_ levelSemiring Dunno x = x
  -- otherwise join
  _*R_ levelSemiring Private Private = Private
  _*R_ levelSemiring Public  Public  = Public
  _*R_ levelSemiring Private Public  = Public
  _*R_ levelSemiring Public Private  = Public

  leftUnit+ levelSemiring {Public}  = refl
  leftUnit+ levelSemiring {Private} = refl
  leftUnit+ levelSemiring {Dunno}   = refl
  leftUnit+ levelSemiring {Unused}  = refl

  rightUnit+ levelSemiring {Public}  = refl
  rightUnit+ levelSemiring {Private} = refl
  rightUnit+ levelSemiring {Dunno}   = refl
  rightUnit+ levelSemiring {Unused}  = refl

  comm+ levelSemiring {Public} {Public} = refl
  comm+ levelSemiring {Public} {Private} = refl
  comm+ levelSemiring {Public} {Dunno} = refl
  comm+ levelSemiring {Public} {Unused} = refl
  comm+ levelSemiring {Private} {Public} = refl
  comm+ levelSemiring {Private} {Private} = refl
  comm+ levelSemiring {Private} {Dunno} = refl
  comm+ levelSemiring {Private} {Unused} = refl
  comm+ levelSemiring {Dunno} {Public} = refl
  comm+ levelSemiring {Dunno} {Private} = refl
  comm+ levelSemiring {Dunno} {Dunno} = refl
  comm+ levelSemiring {Dunno} {Unused} = refl
  comm+ levelSemiring {Unused} {Public} = refl
  comm+ levelSemiring {Unused} {Private} = refl
  comm+ levelSemiring {Unused} {Dunno} = refl
  comm+ levelSemiring {Unused} {Unused} = refl

  leftAbsorb levelSemiring {Public} = refl
  leftAbsorb levelSemiring {Private} = refl
  leftAbsorb levelSemiring {Dunno} = refl
  leftAbsorb levelSemiring {Unused} = refl

  rightAbsorb levelSemiring {Public} = refl
  rightAbsorb levelSemiring {Private} = refl
  rightAbsorb levelSemiring {Dunno} = refl
  rightAbsorb levelSemiring {Unused} = refl

  leftUnit* levelSemiring {Public}   = refl
  leftUnit* levelSemiring {Private}  = refl
  leftUnit* levelSemiring {Dunno}    = refl
  leftUnit* levelSemiring {Unused}   = refl

  rightUnit* levelSemiring {Public}  = refl
  rightUnit* levelSemiring {Private} = refl
  rightUnit* levelSemiring {Dunno}   = refl
  rightUnit* levelSemiring {Unused}  = refl

  assoc* levelSemiring {Public} {Public} {Public} = refl
  assoc* levelSemiring {Public} {Public} {Private} = refl
  assoc* levelSemiring {Public} {Public} {Dunno} = refl
  assoc* levelSemiring {Public} {Public} {Unused} = refl
  assoc* levelSemiring {Public} {Private} {Public} = refl
  assoc* levelSemiring {Public} {Private} {Private} = refl
  assoc* levelSemiring {Public} {Private} {Dunno} = refl
  assoc* levelSemiring {Public} {Private} {Unused} = refl
  assoc* levelSemiring {Public} {Dunno} {Public} = refl
  assoc* levelSemiring {Public} {Dunno} {Private} = refl
  assoc* levelSemiring {Public} {Dunno} {Dunno} = refl
  assoc* levelSemiring {Public} {Dunno} {Unused} = refl
  assoc* levelSemiring {Public} {Unused} {t} = refl
  assoc* levelSemiring {Private} {Public} {Public} = refl
  assoc* levelSemiring {Private} {Public} {Private} = refl
  assoc* levelSemiring {Private} {Public} {Dunno} = refl
  assoc* levelSemiring {Private} {Public} {Unused} = refl
  assoc* levelSemiring {Private} {Private} {Public} = refl
  assoc* levelSemiring {Private} {Private} {Private} = refl
  assoc* levelSemiring {Private} {Private} {Dunno} = refl
  assoc* levelSemiring {Private} {Private} {Unused} = refl
  assoc* levelSemiring {Private} {Dunno} {Public} = refl
  assoc* levelSemiring {Private} {Dunno} {Private} = refl
  assoc* levelSemiring {Private} {Dunno} {Dunno} = refl
  assoc* levelSemiring {Private} {Dunno} {Unused} = refl
  assoc* levelSemiring {Private} {Unused} {t} = refl
  assoc* levelSemiring {Dunno} {Public} {Public} = refl
  assoc* levelSemiring {Dunno} {Public} {Private} = refl
  assoc* levelSemiring {Dunno} {Public} {Dunno} = refl
  assoc* levelSemiring {Dunno} {Public} {Unused} = refl
  assoc* levelSemiring {Dunno} {Private} {Public} = refl
  assoc* levelSemiring {Dunno} {Private} {Private} = refl
  assoc* levelSemiring {Dunno} {Private} {Dunno} = refl
  assoc* levelSemiring {Dunno} {Private} {Unused} = refl
  assoc* levelSemiring {Dunno} {Dunno} {Public} = refl
  assoc* levelSemiring {Dunno} {Dunno} {Private} = refl
  assoc* levelSemiring {Dunno} {Dunno} {Dunno} = refl
  assoc* levelSemiring {Dunno} {Dunno} {Unused} = refl
  assoc* levelSemiring {Dunno} {Unused} {t} = refl
  assoc* levelSemiring {Unused} {s} {t} = refl

  assoc+ levelSemiring {Public} {Public} {Public} = refl
  assoc+ levelSemiring {Public} {Public} {Private} = refl
  assoc+ levelSemiring {Public} {Public} {Dunno} = refl
  assoc+ levelSemiring {Public} {Public} {Unused} = refl
  assoc+ levelSemiring {Public} {Private} {Public} = refl
  assoc+ levelSemiring {Public} {Private} {Private} = refl
  assoc+ levelSemiring {Public} {Private} {Dunno} = refl
  assoc+ levelSemiring {Public} {Private} {Unused} = refl
  assoc+ levelSemiring {Public} {Dunno} {Public} = refl
  assoc+ levelSemiring {Public} {Dunno} {Private} = refl
  assoc+ levelSemiring {Public} {Dunno} {Dunno} = refl
  assoc+ levelSemiring {Public} {Dunno} {Unused} = refl
  assoc+ levelSemiring {Public} {Unused} {t} = refl
  assoc+ levelSemiring {Private} {Public} {Public} = refl
  assoc+ levelSemiring {Private} {Public} {Private} = refl
  assoc+ levelSemiring {Private} {Public} {Dunno} = refl
  assoc+ levelSemiring {Private} {Public} {Unused} = refl
  assoc+ levelSemiring {Private} {Private} {Public} = refl
  assoc+ levelSemiring {Private} {Private} {Private} = refl
  assoc+ levelSemiring {Private} {Private} {Dunno} = refl
  assoc+ levelSemiring {Private} {Private} {Unused} = refl
  assoc+ levelSemiring {Private} {Dunno} {Public} = refl
  assoc+ levelSemiring {Private} {Dunno} {Private} = refl
  assoc+ levelSemiring {Private} {Dunno} {Dunno} = refl
  assoc+ levelSemiring {Private} {Dunno} {Unused} = refl
  assoc+ levelSemiring {Private} {Unused} {t} = refl
  assoc+ levelSemiring {Dunno} {Public} {Public} = refl
  assoc+ levelSemiring {Dunno} {Public} {Private} = refl
  assoc+ levelSemiring {Dunno} {Public} {Dunno} = refl
  assoc+ levelSemiring {Dunno} {Public} {Unused} = refl
  assoc+ levelSemiring {Dunno} {Private} {Public} = refl
  assoc+ levelSemiring {Dunno} {Private} {Private} = refl
  assoc+ levelSemiring {Dunno} {Private} {Dunno} = refl
  assoc+ levelSemiring {Dunno} {Private} {Unused} = refl
  assoc+ levelSemiring {Dunno} {Dunno} {Public} = refl
  assoc+ levelSemiring {Dunno} {Dunno} {Private} = refl
  assoc+ levelSemiring {Dunno} {Dunno} {Dunno} = refl
  assoc+ levelSemiring {Dunno} {Dunno} {Unused} = refl
  assoc+ levelSemiring {Dunno} {Unused} {t} = refl
  assoc+ levelSemiring {Unused} {s} {t} = refl

  distrib1 levelSemiring {Public} {Public} {Public} = refl
  distrib1 levelSemiring {Public} {Public} {Private} = refl
  distrib1 levelSemiring {Public} {Public} {Dunno} = refl
  distrib1 levelSemiring {Public} {Public} {Unused} = refl
  distrib1 levelSemiring {Public} {Private} {Public} = refl
  distrib1 levelSemiring {Public} {Private} {Private} = refl
  distrib1 levelSemiring {Public} {Private} {Dunno} = refl
  distrib1 levelSemiring {Public} {Private} {Unused} = refl
  distrib1 levelSemiring {Public} {Dunno} {Public} = refl
  distrib1 levelSemiring {Public} {Dunno} {Private} = refl
  distrib1 levelSemiring {Public} {Dunno} {Dunno} = refl
  distrib1 levelSemiring {Public} {Dunno} {Unused} = refl
  distrib1 levelSemiring {Public} {Unused} {t} = refl
  distrib1 levelSemiring {Private} {Public} {Public} = refl
  distrib1 levelSemiring {Private} {Public} {Private} = refl
  distrib1 levelSemiring {Private} {Public} {Dunno} = refl
  distrib1 levelSemiring {Private} {Public} {Unused} = refl
  distrib1 levelSemiring {Private} {Private} {Public} = refl
  distrib1 levelSemiring {Private} {Private} {Private} = refl
  distrib1 levelSemiring {Private} {Private} {Dunno} = refl
  distrib1 levelSemiring {Private} {Private} {Unused} = refl
  distrib1 levelSemiring {Private} {Dunno} {Public} = refl
  distrib1 levelSemiring {Private} {Dunno} {Private} = refl
  distrib1 levelSemiring {Private} {Dunno} {Dunno} = refl
  distrib1 levelSemiring {Private} {Dunno} {Unused} = refl
  distrib1 levelSemiring {Private} {Unused} {t} = refl
  distrib1 levelSemiring {Dunno} {Public} {Public} = refl
  distrib1 levelSemiring {Dunno} {Public} {Private} = refl
  distrib1 levelSemiring {Dunno} {Public} {Dunno} = refl
  distrib1 levelSemiring {Dunno} {Public} {Unused} = refl
  distrib1 levelSemiring {Dunno} {Private} {Public} = refl
  distrib1 levelSemiring {Dunno} {Private} {Private} = refl
  distrib1 levelSemiring {Dunno} {Private} {Dunno} = refl
  distrib1 levelSemiring {Dunno} {Private} {Unused} = refl
  distrib1 levelSemiring {Dunno} {Dunno} {Public} = refl
  distrib1 levelSemiring {Dunno} {Dunno} {Private} = refl
  distrib1 levelSemiring {Dunno} {Dunno} {Dunno} = refl
  distrib1 levelSemiring {Dunno} {Dunno} {Unused} = refl
  distrib1 levelSemiring {Dunno} {Unused} {t} = refl
  distrib1 levelSemiring {Unused} {s} {t} = refl

  distrib2 levelSemiring {Public} {Public} {Public} = refl
  distrib2 levelSemiring {Public} {Public} {Private} = refl
  distrib2 levelSemiring {Public} {Public} {Dunno} = refl
  distrib2 levelSemiring {Public} {Public} {Unused} = refl
  distrib2 levelSemiring {Public} {Private} {Public} = refl
  distrib2 levelSemiring {Public} {Private} {Private} = refl
  distrib2 levelSemiring {Public} {Private} {Dunno} = refl
  distrib2 levelSemiring {Public} {Private} {Unused} = refl
  distrib2 levelSemiring {Public} {Dunno} {Public} = refl
  distrib2 levelSemiring {Public} {Dunno} {Private} = refl
  distrib2 levelSemiring {Public} {Dunno} {Dunno} = refl
  distrib2 levelSemiring {Public} {Dunno} {Unused} = refl
  distrib2 levelSemiring {Public} {Unused} {Public} = refl
  distrib2 levelSemiring {Public} {Unused} {Private} = refl
  distrib2 levelSemiring {Public} {Unused} {Dunno} = refl
  distrib2 levelSemiring {Public} {Unused} {Unused} = refl
  distrib2 levelSemiring {Private} {Public} {Public} = refl
  distrib2 levelSemiring {Private} {Public} {Private} = refl
  distrib2 levelSemiring {Private} {Public} {Dunno} = refl
  distrib2 levelSemiring {Private} {Public} {Unused} = refl
  distrib2 levelSemiring {Private} {Private} {Public} = refl
  distrib2 levelSemiring {Private} {Private} {Private} = refl
  distrib2 levelSemiring {Private} {Private} {Dunno} = refl
  distrib2 levelSemiring {Private} {Private} {Unused} = refl
  distrib2 levelSemiring {Private} {Dunno} {Public} = refl
  distrib2 levelSemiring {Private} {Dunno} {Private} = refl
  distrib2 levelSemiring {Private} {Dunno} {Dunno} = refl
  distrib2 levelSemiring {Private} {Dunno} {Unused} = refl
  distrib2 levelSemiring {Private} {Unused} {Public} = refl
  distrib2 levelSemiring {Private} {Unused} {Private} = refl
  distrib2 levelSemiring {Private} {Unused} {Dunno} = refl
  distrib2 levelSemiring {Private} {Unused} {Unused} = refl
  distrib2 levelSemiring {Dunno} {Public} {Public} = refl
  distrib2 levelSemiring {Dunno} {Public} {Private} = refl
  distrib2 levelSemiring {Dunno} {Public} {Dunno} = refl
  distrib2 levelSemiring {Dunno} {Public} {Unused} = refl
  distrib2 levelSemiring {Dunno} {Private} {Public} = refl
  distrib2 levelSemiring {Dunno} {Private} {Private} = refl
  distrib2 levelSemiring {Dunno} {Private} {Dunno} = refl
  distrib2 levelSemiring {Dunno} {Private} {Unused} = refl
  distrib2 levelSemiring {Dunno} {Dunno} {Public} = refl
  distrib2 levelSemiring {Dunno} {Dunno} {Private} = refl
  distrib2 levelSemiring {Dunno} {Dunno} {Dunno} = refl
  distrib2 levelSemiring {Dunno} {Dunno} {Unused} = refl
  distrib2 levelSemiring {Dunno} {Unused} {Public} = refl
  distrib2 levelSemiring {Dunno} {Unused} {Private} = refl
  distrib2 levelSemiring {Dunno} {Unused} {Dunno} = refl
  distrib2 levelSemiring {Dunno} {Unused} {Unused} = refl
  distrib2 levelSemiring {Unused} {Public} {Public} = refl
  distrib2 levelSemiring {Unused} {Public} {Private} = refl
  distrib2 levelSemiring {Unused} {Public} {Dunno} = refl
  distrib2 levelSemiring {Unused} {Public} {Unused} = refl
  distrib2 levelSemiring {Unused} {Private} {Public} = refl
  distrib2 levelSemiring {Unused} {Private} {Private} = refl
  distrib2 levelSemiring {Unused} {Private} {Dunno} = refl
  distrib2 levelSemiring {Unused} {Private} {Unused} = refl
  distrib2 levelSemiring {Unused} {Dunno} {Public} = refl
  distrib2 levelSemiring {Unused} {Dunno} {Private} = refl
  distrib2 levelSemiring {Unused} {Dunno} {Dunno} = refl
  distrib2 levelSemiring {Unused} {Dunno} {Unused} = refl
  distrib2 levelSemiring {Unused} {Unused} {t} = refl

  monotone* levelSemiring 0Pub 0Pub = 0Pub
  monotone* levelSemiring 0Pub 0Priv = 0Pub
  monotone* levelSemiring 0Pub PrivPub = 0Pub
  monotone* levelSemiring 0Pub 0Dunno = 0Pub
  monotone* levelSemiring 0Pub PrivDunno = 0Pub
  monotone* levelSemiring 0Pub (Refl Public) = 0Pub
  monotone* levelSemiring 0Pub (Refl Private) = 0Pub
  monotone* levelSemiring 0Pub (Refl Dunno) = 0Pub
  monotone* levelSemiring 0Pub (Refl Unused) = Refl Unused
  monotone* levelSemiring 0Priv 0Pub = 0Pub
  monotone* levelSemiring 0Priv 0Priv = 0Priv
  monotone* levelSemiring 0Priv PrivPub = 0Pub
  monotone* levelSemiring 0Priv 0Dunno = 0Dunno
  monotone* levelSemiring 0Priv PrivDunno = 0Dunno
  monotone* levelSemiring 0Priv (Refl Public) = 0Pub
  monotone* levelSemiring 0Priv (Refl Private) = 0Priv
  monotone* levelSemiring 0Priv (Refl Dunno) = 0Dunno
  monotone* levelSemiring 0Priv (Refl Unused) = Refl Unused
  monotone* levelSemiring PrivPub 0Pub = 0Pub
  monotone* levelSemiring PrivPub 0Priv = 0Pub
  monotone* levelSemiring PrivPub PrivPub = PrivPub
  monotone* levelSemiring PrivPub 0Dunno = 0Pub
  monotone* levelSemiring PrivPub PrivDunno = PrivPub
  monotone* levelSemiring PrivPub (Refl Public) = Refl Public
  monotone* levelSemiring PrivPub (Refl Private) = PrivPub
  -- Private <= Pub   Dunno <= Dunno
  -- --------------------------------------
   --    Private * Dunno <= Pub * Dunno
   --       Dunno        <= Pub    (didn't have this previously 24/06/2021).
  monotone* levelSemiring PrivPub (Refl Dunno) = DunnoPub
  monotone* levelSemiring PrivPub (Refl Unused) = Refl Unused
  monotone* levelSemiring 0Dunno 0Pub = 0Pub
  monotone* levelSemiring 0Dunno 0Priv = 0Dunno
  monotone* levelSemiring 0Dunno PrivPub = 0Pub
  monotone* levelSemiring 0Dunno 0Dunno = 0Dunno
  monotone* levelSemiring 0Dunno PrivDunno = 0Dunno
  monotone* levelSemiring 0Dunno (Refl Public) = 0Pub
  monotone* levelSemiring 0Dunno (Refl Private) = 0Dunno
  monotone* levelSemiring 0Dunno (Refl Dunno) = 0Dunno
  monotone* levelSemiring 0Dunno (Refl Unused) = Refl Unused
  monotone* levelSemiring PrivDunno 0Pub = 0Pub
  monotone* levelSemiring PrivDunno 0Priv = 0Dunno
  monotone* levelSemiring PrivDunno PrivPub = PrivPub
  monotone* levelSemiring PrivDunno 0Dunno = 0Dunno
  monotone* levelSemiring PrivDunno PrivDunno = PrivDunno
  monotone* levelSemiring PrivDunno (Refl Public) = Refl Public
  monotone* levelSemiring PrivDunno (Refl Private) = PrivDunno
  monotone* levelSemiring PrivDunno (Refl Dunno) = Refl Dunno
  monotone* levelSemiring PrivDunno (Refl Unused) = Refl Unused
  monotone* levelSemiring (Refl Public) 0Pub = 0Pub
  monotone* levelSemiring (Refl Private) 0Pub = 0Pub
  monotone* levelSemiring (Refl Dunno) 0Pub = 0Pub
  monotone* levelSemiring (Refl Unused) 0Pub = Refl Unused
  monotone* levelSemiring (Refl Public) 0Priv = 0Pub
  monotone* levelSemiring (Refl Private) 0Priv = 0Priv
  monotone* levelSemiring (Refl Dunno) 0Priv = 0Dunno
  monotone* levelSemiring (Refl Unused) 0Priv = Refl Unused
  monotone* levelSemiring (Refl Public) PrivPub = Refl Public
  monotone* levelSemiring (Refl Private) PrivPub = PrivPub
  monotone* levelSemiring (Refl Dunno) PrivPub = DunnoPub
  monotone* levelSemiring (Refl Unused) PrivPub = Refl Unused
  monotone* levelSemiring (Refl Public) 0Dunno = 0Pub
  monotone* levelSemiring (Refl Private) 0Dunno = 0Dunno
  monotone* levelSemiring (Refl Dunno) 0Dunno = 0Dunno
  monotone* levelSemiring (Refl Unused) 0Dunno = Refl Unused
  monotone* levelSemiring (Refl Public) PrivDunno = Refl Public
  monotone* levelSemiring (Refl Private) PrivDunno = PrivDunno
  monotone* levelSemiring (Refl Dunno) PrivDunno = Refl Dunno
  monotone* levelSemiring (Refl Unused) PrivDunno = Refl Unused
  monotone* levelSemiring (Refl Public) (Refl Public) = Refl Public
  monotone* levelSemiring (Refl Public) (Refl Private) = Refl Public
  monotone* levelSemiring (Refl Public) (Refl Dunno) = Refl Public
  monotone* levelSemiring (Refl Public) (Refl Unused) = Refl Unused
  monotone* levelSemiring (Refl Private) (Refl Public) = Refl Public
  monotone* levelSemiring (Refl Private) (Refl Private) = Refl Private
  monotone* levelSemiring (Refl Private) (Refl Dunno) = Refl Dunno
  monotone* levelSemiring (Refl Private) (Refl Unused) = Refl Unused
  monotone* levelSemiring (Refl Dunno) (Refl Public) = Refl Public
  monotone* levelSemiring (Refl Dunno) (Refl Private) = Refl Dunno
  monotone* levelSemiring (Refl Dunno) (Refl Dunno) = Refl Dunno
  monotone* levelSemiring (Refl Dunno) (Refl Unused) = Refl Unused
  monotone* levelSemiring (Refl Unused) (Refl r) = Refl Unused
  monotone* levelSemiring 0Pub DunnoPub = 0Pub
  monotone* levelSemiring 0Priv DunnoPub = 0Pub
  monotone* levelSemiring PrivPub DunnoPub = DunnoPub
  monotone* levelSemiring 0Dunno DunnoPub = 0Pub
  monotone* levelSemiring PrivDunno DunnoPub = DunnoPub
  monotone* levelSemiring DunnoPub 0Pub = 0Pub
  monotone* levelSemiring DunnoPub 0Priv = 0Pub
  monotone* levelSemiring DunnoPub PrivPub = DunnoPub
  monotone* levelSemiring DunnoPub 0Dunno = 0Pub
  monotone* levelSemiring DunnoPub PrivDunno = DunnoPub
  monotone* levelSemiring DunnoPub DunnoPub = DunnoPub
  monotone* levelSemiring DunnoPub (Refl Public) = Refl Public
  monotone* levelSemiring DunnoPub (Refl Private) = DunnoPub
  monotone* levelSemiring DunnoPub (Refl Dunno) = DunnoPub
  monotone* levelSemiring DunnoPub (Refl Unused) = Refl Unused
  monotone* levelSemiring (Refl Public) DunnoPub = Refl Public
  monotone* levelSemiring (Refl Private) DunnoPub = DunnoPub
  monotone* levelSemiring (Refl Dunno) DunnoPub = DunnoPub
  monotone* levelSemiring (Refl Unused) DunnoPub = Refl Unused

  monotone+ levelSemiring {Public} {Public} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Public} {Private} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Public} {Dunno} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Public} {Unused} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Private} {Private} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Private} {Unused} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Dunno} {Private} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Dunno} {Dunno} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Dunno} {Unused} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Public} {Unused} {Unused} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Private} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Private} {Public} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Private} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Private} {Public} {Unused} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Private} {Private} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Private} {Private} {Unused} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Private} {Dunno} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Private} {Dunno} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Private} {Dunno} {Unused} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Private} {Unused} {Unused} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Dunno} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Dunno} {Public} {Private} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Public} {Unused} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Private} {Private} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Private} {Unused} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Dunno} {Private} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Dunno} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Dunno} {Unused} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Dunno} {Unused} {Unused} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Unused} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Public} {Unused} {Public} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Unused} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Unused} {Public} {Unused} pre1 pre2 = 0Pub
  monotone+ levelSemiring {Public} {Unused} {Private} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Unused} {Private} {Unused} pre1 pre2 = 0Pub
  monotone+ levelSemiring {Public} {Unused} {Dunno} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Public} {Unused} {Dunno} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Public} {Unused} {Dunno} {Unused} pre1 pre2 = 0Pub
  monotone+ levelSemiring {Public} {Unused} {Unused} {Unused} pre1 pre2 = 0Pub
  monotone+ levelSemiring {Private} {Private} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Private} {Private} {Public} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Private} {Private} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Private} {Private} {Public} {Unused} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Private} {Private} {Private} {Private} pre1 pre2 = Refl Private
  monotone+ levelSemiring {Private} {Private} {Private} {Unused} pre1 pre2 = Refl Private
  monotone+ levelSemiring {Private} {Private} {Dunno} {Private} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Private} {Private} {Dunno} {Dunno} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Private} {Private} {Dunno} {Unused} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Private} {Private} {Unused} {Unused} pre1 pre2 = Refl Private
  monotone+ levelSemiring {Private} {Unused} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Private} {Unused} {Public} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Private} {Unused} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Private} {Unused} {Public} {Unused} pre1 pre2 = 0Pub
  monotone+ levelSemiring {Private} {Unused} {Private} {Private} pre1 pre2 = Refl Private
  monotone+ levelSemiring {Private} {Unused} {Private} {Unused} pre1 pre2 = 0Priv
  monotone+ levelSemiring {Private} {Unused} {Dunno} {Private} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Private} {Unused} {Dunno} {Dunno} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Private} {Unused} {Dunno} {Unused} pre1 pre2 = 0Dunno
  monotone+ levelSemiring {Private} {Unused} {Unused} {Unused} pre1 pre2 = 0Priv
  monotone+ levelSemiring {Dunno} {Private} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Dunno} {Private} {Public} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Dunno} {Private} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Dunno} {Private} {Public} {Unused} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Dunno} {Private} {Private} {Private} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Dunno} {Private} {Private} {Unused} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Dunno} {Private} {Dunno} {Private} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Dunno} {Private} {Dunno} {Dunno} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Private} {Dunno} {Unused} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Dunno} {Private} {Unused} {Unused} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Dunno} {Dunno} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Dunno} {Dunno} {Public} {Private} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Dunno} {Dunno} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Dunno} {Dunno} {Public} {Unused} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Dunno} {Dunno} {Private} {Private} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Dunno} {Private} {Unused} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Dunno} {Dunno} {Private} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Dunno} {Dunno} {Dunno} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Dunno} {Dunno} {Unused} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Dunno} {Unused} {Unused} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Unused} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Dunno} {Unused} {Public} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Dunno} {Unused} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Dunno} {Unused} {Public} {Unused} pre1 pre2 = 0Pub
  monotone+ levelSemiring {Dunno} {Unused} {Private} {Private} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Dunno} {Unused} {Private} {Unused} pre1 pre2 = 0Dunno
  monotone+ levelSemiring {Dunno} {Unused} {Dunno} {Private} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Dunno} {Unused} {Dunno} {Dunno} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Dunno} {Unused} {Dunno} {Unused} pre1 pre2 = 0Dunno
  monotone+ levelSemiring {Dunno} {Unused} {Unused} {Unused} pre1 pre2 = 0Dunno
  monotone+ levelSemiring {Unused} {Unused} {Public} {Public} pre1 pre2 = Refl Public
  monotone+ levelSemiring {Unused} {Unused} {Public} {Private} pre1 pre2 = PrivPub
  monotone+ levelSemiring {Unused} {Unused} {Public} {Dunno} pre1 pre2 = DunnoPub
  monotone+ levelSemiring {Unused} {Unused} {Public} {Unused} pre1 pre2 = 0Pub
  monotone+ levelSemiring {Unused} {Unused} {Private} {Private} pre1 pre2 = Refl Private
  monotone+ levelSemiring {Unused} {Unused} {Private} {Unused} pre1 pre2 = 0Priv
  monotone+ levelSemiring {Unused} {Unused} {Dunno} {Private} pre1 pre2 = PrivDunno
  monotone+ levelSemiring {Unused} {Unused} {Dunno} {Dunno} pre1 pre2 = Refl Dunno
  monotone+ levelSemiring {Unused} {Unused} {Dunno} {Unused} pre1 pre2 = 0Dunno
  monotone+ levelSemiring {Unused} {Unused} {Unused} {Unused} pre1 pre2 = Refl Unused

  reflexive≤ levelSemiring {r} = Refl r

  transitive≤ levelSemiring {Public} {Public} {Public} inp1 inp2 = Refl Public
  transitive≤ levelSemiring {Public} {Public} {Private} inp1 inp2 = PrivPub
  transitive≤ levelSemiring {Public} {Public} {Dunno} inp1 inp2 = DunnoPub
  transitive≤ levelSemiring {Public} {Public} {Unused} inp1 inp2 = 0Pub
  transitive≤ levelSemiring {Public} {Private} {Public} inp1 inp2 = Refl Public
  transitive≤ levelSemiring {Public} {Private} {Private} inp1 inp2 = PrivPub
  transitive≤ levelSemiring {Public} {Private} {Dunno} inp1 inp2 = DunnoPub
  transitive≤ levelSemiring {Public} {Private} {Unused} inp1 inp2 = 0Pub
  transitive≤ levelSemiring {Public} {Dunno} {Public} inp1 inp2 = Refl Public
  transitive≤ levelSemiring {Public} {Dunno} {Private} inp1 inp2 = PrivPub
  transitive≤ levelSemiring {Public} {Dunno} {Dunno} inp1 inp2 = DunnoPub
  transitive≤ levelSemiring {Public} {Dunno} {Unused} inp1 inp2 = 0Pub
  transitive≤ levelSemiring {Public} {Unused} {Public} inp1 inp2 = Refl Public
  transitive≤ levelSemiring {Public} {Unused} {Private} inp1 inp2 = PrivPub
  transitive≤ levelSemiring {Public} {Unused} {Dunno} inp1 inp2 = DunnoPub
  transitive≤ levelSemiring {Public} {Unused} {Unused} inp1 inp2 = 0Pub
  transitive≤ levelSemiring {Private} {Public} {Public} () inp2
  transitive≤ levelSemiring {Private} {Public} {Private} inp1 inp2 = Refl Private
  transitive≤ levelSemiring {Private} {Public} {Dunno} () inp2
  transitive≤ levelSemiring {Private} {Public} {Unused} inp1 inp2 = 0Priv
  transitive≤ levelSemiring {Private} {Private} {Public} inp1 ()
  transitive≤ levelSemiring {Private} {Private} {Private} inp1 inp2 = Refl Private
  transitive≤ levelSemiring {Private} {Private} {Dunno} inp1 ()
  transitive≤ levelSemiring {Private} {Private} {Unused} inp1 inp2 = 0Priv
  transitive≤ levelSemiring {Private} {Dunno} {Public} inp1 ()
  transitive≤ levelSemiring {Private} {Dunno} {Private} inp1 inp2 = Refl Private
  transitive≤ levelSemiring {Private} {Dunno} {Dunno} () inp2
  transitive≤ levelSemiring {Private} {Dunno} {Unused} inp1 inp2 = 0Priv
  transitive≤ levelSemiring {Private} {Unused} {Public} inp1 ()
  transitive≤ levelSemiring {Private} {Unused} {Private} inp1 inp2 = Refl Private
  transitive≤ levelSemiring {Private} {Unused} {Dunno} inp1 ()
  transitive≤ levelSemiring {Private} {Unused} {Unused} inp1 inp2 = 0Priv
  transitive≤ levelSemiring {Dunno} {Public} {Public} () inp2
  transitive≤ levelSemiring {Dunno} {Public} {Private} () inp2
  transitive≤ levelSemiring {Dunno} {Public} {Dunno} inp1 inp2 = Refl Dunno
  transitive≤ levelSemiring {Dunno} {Public} {Unused} inp1 inp2 = 0Dunno
  transitive≤ levelSemiring {Dunno} {Private} {Public} inp1 ()
  transitive≤ levelSemiring {Dunno} {Private} {Private} inp1 inp2 = PrivDunno
  transitive≤ levelSemiring {Dunno} {Private} {Dunno} inp1 inp2 = Refl Dunno
  transitive≤ levelSemiring {Dunno} {Private} {Unused} inp1 inp2 = 0Dunno
  transitive≤ levelSemiring {Dunno} {Dunno} {Public} inp1 ()
  transitive≤ levelSemiring {Dunno} {Dunno} {Private} inp1 inp2 = PrivDunno
  transitive≤ levelSemiring {Dunno} {Dunno} {Dunno} inp1 inp2 = Refl Dunno
  transitive≤ levelSemiring {Dunno} {Dunno} {Unused} inp1 inp2 = 0Dunno
  transitive≤ levelSemiring {Dunno} {Unused} {Public} inp1 ()
  transitive≤ levelSemiring {Dunno} {Unused} {Private} inp1 inp2 = PrivDunno
  transitive≤ levelSemiring {Dunno} {Unused} {Dunno} inp1 inp2 = Refl Dunno
  transitive≤ levelSemiring {Dunno} {Unused} {Unused} inp1 inp2 = 0Dunno
  transitive≤ levelSemiring {Unused} {Public} {t} () inp2
  transitive≤ levelSemiring {Unused} {Private} {t} () inp2
  transitive≤ levelSemiring {Unused} {Dunno} {t} () inp2
  transitive≤ levelSemiring {Unused} {Unused} {Unused} inp1 inp2 = Refl Unused

instance
  levelSemiringNonInterfering : NonInterferingSemiring levelSemiring
  -- does not hold for Level which is the key
  oneIsBottom levelSemiringNonInterfering {r} = {!!}

  antisymmetry levelSemiringNonInterfering {Public} {Public} (Refl .Public) pre2 = refl
  antisymmetry levelSemiringNonInterfering {Private} {Public} () pre2
  antisymmetry levelSemiringNonInterfering {Private} {Private} (Refl .Private) pre2 = refl
  antisymmetry levelSemiringNonInterfering {Private} {Dunno} () pre2
  antisymmetry levelSemiringNonInterfering {Dunno} {Public} () pre2
  antisymmetry levelSemiringNonInterfering {Dunno} {Dunno} (Refl .Dunno) pre2 = refl
  antisymmetry levelSemiringNonInterfering {Unused} {Public} () pre2
  antisymmetry levelSemiringNonInterfering {Unused} {Private} () pre2
  antisymmetry levelSemiringNonInterfering {Unused} {Dunno} () pre2
  antisymmetry levelSemiringNonInterfering {Unused} {Unused} (Refl .Unused) pre2 = refl

  decreasing+ levelSemiringNonInterfering {r1} {Unused} {adv} pre rewrite rightUnit+ levelSemiring {r1} = pre
  decreasing+ levelSemiringNonInterfering {Public} {Public} {adv}  pre = pre
  decreasing+ levelSemiringNonInterfering {Private} {Public} {adv} pre = transitive≤ levelSemiring PrivPub pre
  decreasing+ levelSemiringNonInterfering {Dunno} {Public} {adv}   pre = transitive≤ levelSemiring DunnoPub  pre
  decreasing+ levelSemiringNonInterfering {Unused} {Public} {Unused} pre = 0Pub
  decreasing+ levelSemiringNonInterfering {Public} {Private} {adv} pre = pre
  decreasing+ levelSemiringNonInterfering {Private} {Private} {adv} pre = pre
  decreasing+ levelSemiringNonInterfering {Dunno} {Private} {adv} pre = pre
  decreasing+ levelSemiringNonInterfering {Unused} {Private} {Unused} pre = 0Priv
  decreasing+ levelSemiringNonInterfering {Unused} {Dunno} {Unused} pre = 0Dunno
  decreasing+ levelSemiringNonInterfering {Public} {Dunno} {adv}  pre = pre
  decreasing+ levelSemiringNonInterfering {Private} {Dunno} {adv} pre = transitive≤ levelSemiring PrivDunno pre
  decreasing+ levelSemiringNonInterfering {Dunno} {Dunno} {adv}   pre = pre

  propertyConditionalNI levelSemiringNonInterfering {Public} {Public} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Public} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Public} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Private} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Private} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Private} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Dunno} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Dunno} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Dunno} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Unused} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Unused} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Public} {Unused} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Private} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Dunno} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Public} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Private} {Public} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Private} {Private} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Private} {Dunno} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Private} {Unused} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Private} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Private} {Unused} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Private} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Dunno} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Public} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Dunno} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Private} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Dunno} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Public} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Public} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Public} {Private} inp1 inp2 = λ _ -> inp1 (Refl Private)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Public} {Dunno} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Priv
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Private} {Private} inp1 inp2 = λ _ -> inp1 (Refl Private)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Private} {Dunno} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Priv
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 (Refl Private)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Dunno} {Dunno} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Private} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Priv
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Public} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Dunno} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Public} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Public} {Private} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Private} {Private} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Dunno} {Private} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Public} {Dunno} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Private} {Dunno} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Dunno} {Dunno} inp1 inp2 ()
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Public} {Unused} inp1 inp2 = λ _ -> inp1 (Refl Unused)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Private} {Unused} inp1 inp2 = λ _ -> inp1 (Refl Unused)
  propertyConditionalNI levelSemiringNonInterfering {Unused} {Unused} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 (Refl Unused)

  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Public} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Public} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Public} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Private} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Dunno} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Private} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Private} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Dunno} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Dunno} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Private} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Dunno} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Public} {Unused} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Public} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Public} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Public} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Private} {Private} inp1 inp2 = λ _ -> inp1 (Refl Private)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Private} {Dunno} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Priv
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Dunno} {Dunno} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Private} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Dunno} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Private} {Private} inp1 inp2 = λ _ -> inp1 (Refl Private)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Private} {Dunno} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Priv
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI2 levelSemiringNonInterfering {Private} {Unused} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Public} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Public} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Public} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Private} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Dunno} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Dunno} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Dunno} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Public} {Public} inp1 inp2 = λ _ -> inp1 (Refl Public)
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Public} {Private} inp1 inp2 = λ _ -> inp1 PrivPub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Public} {Dunno} inp1 inp2 = λ _ -> inp1 DunnoPub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Public} {Unused} inp1 inp2 = λ _ -> inp1 0Pub
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Private} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Private} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Private} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Private} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Public} inp1 inp2 ()
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Private} inp1 inp2 = λ _ -> inp1 PrivDunno
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Dunno} inp1 inp2 = λ _ -> inp1 (Refl Dunno)
  propertyConditionalNI2 levelSemiringNonInterfering {Dunno} {Unused} {Dunno} {Unused} inp1 inp2 = λ _ -> inp1 0Dunno
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Public} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Public} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Public} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Private} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Private} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Private} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Dunno} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Dunno} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Dunno} {Dunno} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Unused} {Public} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Unused} {Private} {adv} inp1 inp2 = inp1
  propertyConditionalNI2 levelSemiringNonInterfering {Unused} {Unused} {Dunno} {adv} inp1 inp2 = inp1


  idem* levelSemiringNonInterfering {Public} = refl
  idem* levelSemiringNonInterfering {Private} = refl
  idem* levelSemiringNonInterfering {Dunno} = refl
  idem* levelSemiringNonInterfering {Unused} = refl

instance
  levelIFstructure : InformationFlowSemiring levelSemiring

  default levelIFstructure = Dunno

  _#_ levelIFstructure Private s = Private
  _#_ levelIFstructure r Private = Private
  -- some debate here
  _#_ levelIFstructure r s = _*R_ levelSemiring r s

  --substProp levelIFstructure {Public} = {!!}
  --substProp levelIFstructure {Private} = refl
  --substProp levelIFstructure {Dunno} = {!!}
  --substProp levelIFstructure {Unused} = refl

  unit# levelIFstructure {Public}  = refl
  unit# levelIFstructure {Private} = refl
  unit# levelIFstructure {Dunno}   = refl
  unit# levelIFstructure {Unused}  = refl -- <- doesn't hold if *R is actually +R

  comm# levelIFstructure {Public} {Public} = refl
  comm# levelIFstructure {Public} {Private} = refl
  comm# levelIFstructure {Public} {Dunno} = refl
  comm# levelIFstructure {Public} {Unused} = refl
  comm# levelIFstructure {Private} {Public} = refl
  comm# levelIFstructure {Private} {Private} = refl
  comm# levelIFstructure {Private} {Dunno} = refl
  comm# levelIFstructure {Private} {Unused} = refl
  comm# levelIFstructure {Dunno} {Public} = refl
  comm# levelIFstructure {Dunno} {Private} = refl
  comm# levelIFstructure {Dunno} {Dunno} = refl
  comm# levelIFstructure {Dunno} {Unused} = refl
  comm# levelIFstructure {Unused} {Public} = refl
  comm# levelIFstructure {Unused} {Private} = refl
  comm# levelIFstructure {Unused} {Dunno} = refl
  comm# levelIFstructure {Unused} {Unused} = refl

  assoc# levelIFstructure {Public} {Public} {Public} = refl
  assoc# levelIFstructure {Public} {Public} {Private} = refl
  assoc# levelIFstructure {Public} {Public} {Dunno} = refl
  assoc# levelIFstructure {Public} {Public} {Unused} = refl
  assoc# levelIFstructure {Public} {Private} {t} = refl
  assoc# levelIFstructure {Public} {Dunno} {Public} = refl
  assoc# levelIFstructure {Public} {Dunno} {Private} = refl
  assoc# levelIFstructure {Public} {Dunno} {Dunno} = refl
  assoc# levelIFstructure {Public} {Dunno} {Unused} = refl
  assoc# levelIFstructure {Public} {Unused} {Public} = refl
  assoc# levelIFstructure {Public} {Unused} {Private} = refl
  assoc# levelIFstructure {Public} {Unused} {Dunno} = refl
  assoc# levelIFstructure {Public} {Unused} {Unused} = refl
  assoc# levelIFstructure {Private} {s} {t} = refl
  assoc# levelIFstructure {Dunno} {Public} {Public} = refl
  assoc# levelIFstructure {Dunno} {Public} {Private} = refl
  assoc# levelIFstructure {Dunno} {Public} {Dunno} = refl
  assoc# levelIFstructure {Dunno} {Public} {Unused} = refl
  assoc# levelIFstructure {Dunno} {Private} {t} = refl
  assoc# levelIFstructure {Dunno} {Dunno} {Public} = refl
  assoc# levelIFstructure {Dunno} {Dunno} {Private} = refl
  assoc# levelIFstructure {Dunno} {Dunno} {Dunno} = refl
  assoc# levelIFstructure {Dunno} {Dunno} {Unused} = refl
  assoc# levelIFstructure {Dunno} {Unused} {Public} = refl
  assoc# levelIFstructure {Dunno} {Unused} {Private} = refl
  assoc# levelIFstructure {Dunno} {Unused} {Dunno} = refl
  assoc# levelIFstructure {Dunno} {Unused} {Unused} = refl
  assoc# levelIFstructure {Unused} {Public} {Public} = refl
  assoc# levelIFstructure {Unused} {Public} {Private} = refl
  assoc# levelIFstructure {Unused} {Public} {Dunno} = refl
  assoc# levelIFstructure {Unused} {Public} {Unused} = refl
  assoc# levelIFstructure {Unused} {Private} {t} = refl
  assoc# levelIFstructure {Unused} {Dunno} {Public} = refl
  assoc# levelIFstructure {Unused} {Dunno} {Private} = refl
  assoc# levelIFstructure {Unused} {Dunno} {Dunno} = refl
  assoc# levelIFstructure {Unused} {Dunno} {Unused} = refl
  assoc# levelIFstructure {Unused} {Unused} {Public} = refl
  assoc# levelIFstructure {Unused} {Unused} {Private} = refl
  assoc# levelIFstructure {Unused} {Unused} {Dunno} = refl
  assoc# levelIFstructure {Unused} {Unused} {Unused} = refl

  idem# levelIFstructure {Public}  = refl
  idem# levelIFstructure {Private} = refl
  idem# levelIFstructure {Dunno}   = refl
  idem# levelIFstructure {Unused}  = refl

  absorb# levelIFstructure {Public}  = refl
  absorb# levelIFstructure {Private} = refl
  absorb# levelIFstructure {Dunno}   = refl
  absorb# levelIFstructure {Unused}  = refl

  idem* levelIFstructure {Public} = refl
  idem* levelIFstructure {Private} = refl
  idem* levelIFstructure {Dunno} = refl
  idem* levelIFstructure {Unused} = refl

  decreasing+ levelIFstructure = decreasing+ levelSemiringNonInterfering

  timesLeft levelIFstructure {Public} {Public} {Public} (Refl .Public) = ?
  timesLeft levelIFstructure {Public} {Public} {Private} PrivPub = ?
  timesLeft levelIFstructure {Public} {Public} {Dunno} DunnoPub = ?
  timesLeft levelIFstructure {Public} {Public} {Unused} 0Pub = ?
  timesLeft levelIFstructure {Public} {Private} {Public} (Refl .Public) = ?
  timesLeft levelIFstructure {Public} {Private} {Private} PrivPub = ?
  timesLeft levelIFstructure {Public} {Private} {Dunno} DunnoPub = ?
  timesLeft levelIFstructure {Public} {Private} {Unused} 0Pub = ?
  timesLeft levelIFstructure {Public} {Dunno} {Public} (Refl .Public) = ?
  timesLeft levelIFstructure {Public} {Dunno} {Private} PrivPub = ?
  timesLeft levelIFstructure {Public} {Dunno} {Dunno} DunnoPub = ?
  timesLeft levelIFstructure {Public} {Dunno} {Unused} 0Pub = ?
  timesLeft levelIFstructure {Public} {Unused} {Public} (Refl .Public) = ?
  timesLeft levelIFstructure {Public} {Unused} {Private} PrivPub = ?
  timesLeft levelIFstructure {Public} {Unused} {Dunno} DunnoPub = ?
  timesLeft levelIFstructure {Public} {Unused} {Unused} 0Pub = ?
  timesLeft levelIFstructure {Private} {Public} {Public} ()
  timesLeft levelIFstructure {Private} {Public} {Private} (Refl .Private) = ?
  timesLeft levelIFstructure {Private} {Public} {Dunno} ()
  timesLeft levelIFstructure {Private} {Public} {Unused} 0Priv = ?
  timesLeft levelIFstructure {Private} {Private} {Public} ()
  timesLeft levelIFstructure {Private} {Private} {Private} (Refl .Private) = ?
  timesLeft levelIFstructure {Private} {Private} {Dunno} ()
  timesLeft levelIFstructure {Private} {Private} {Unused} 0Priv = ?
  timesLeft levelIFstructure {Private} {Dunno} {Public} ()
  timesLeft levelIFstructure {Private} {Dunno} {Private} (Refl .Private) = ?
  timesLeft levelIFstructure {Private} {Dunno} {Dunno} ()
  timesLeft levelIFstructure {Private} {Dunno} {Unused} 0Priv = ?
  timesLeft levelIFstructure {Private} {Unused} {Public} ()
  timesLeft levelIFstructure {Private} {Unused} {Private} (Refl .Private) = ?
  timesLeft levelIFstructure {Private} {Unused} {Dunno} ()
  timesLeft levelIFstructure {Private} {Unused} {Unused} 0Priv = ?
  timesLeft levelIFstructure {Dunno} {Public} {Public} ()
  timesLeft levelIFstructure {Dunno} {Public} {Private} PrivDunno = ?
  timesLeft levelIFstructure {Dunno} {Public} {Dunno} (Refl .Dunno) = ?
  timesLeft levelIFstructure {Dunno} {Public} {Unused} 0Dunno = ?
  timesLeft levelIFstructure {Dunno} {Private} {Public} ()
  timesLeft levelIFstructure {Dunno} {Private} {Private} PrivDunno = ?
  timesLeft levelIFstructure {Dunno} {Private} {Dunno} (Refl .Dunno) = ?
  timesLeft levelIFstructure {Dunno} {Private} {Unused} 0Dunno = ?
  timesLeft levelIFstructure {Dunno} {Dunno} {Public} ()
  timesLeft levelIFstructure {Dunno} {Dunno} {Private} PrivDunno = ?
  timesLeft levelIFstructure {Dunno} {Dunno} {Dunno} (Refl .Dunno) = ?
  timesLeft levelIFstructure {Dunno} {Dunno} {Unused} 0Dunno = ?
  timesLeft levelIFstructure {Dunno} {Unused} {Public} ()
  timesLeft levelIFstructure {Dunno} {Unused} {Private} PrivDunno = ?
  timesLeft levelIFstructure {Dunno} {Unused} {Dunno} (Refl .Dunno) = ?
  timesLeft levelIFstructure {Dunno} {Unused} {Unused} 0Dunno = ?
  timesLeft levelIFstructure {Unused} {Public} {Public} ()
  timesLeft levelIFstructure {Unused} {Public} {Private} ()
  timesLeft levelIFstructure {Unused} {Public} {Dunno} ()
  timesLeft levelIFstructure {Unused} {Public} {Unused} (Refl .Unused) = ?
  timesLeft levelIFstructure {Unused} {Private} {Public} ()
  timesLeft levelIFstructure {Unused} {Private} {Private} ()
  timesLeft levelIFstructure {Unused} {Private} {Dunno} ()
  timesLeft levelIFstructure {Unused} {Private} {Unused} (Refl .Unused) = ?
  timesLeft levelIFstructure {Unused} {Dunno} {Public} ()
  timesLeft levelIFstructure {Unused} {Dunno} {Private} ()
  timesLeft levelIFstructure {Unused} {Dunno} {Dunno} ()
  timesLeft levelIFstructure {Unused} {Dunno} {Unused} (Refl .Unused) = ?
  timesLeft levelIFstructure {Unused} {Unused} {Public} ()
  timesLeft levelIFstructure {Unused} {Unused} {Private} ()
  timesLeft levelIFstructure {Unused} {Unused} {Dunno} ()
  timesLeft levelIFstructure {Unused} {Unused} {Unused} (Refl .Unused) = ?

  leftAbsorbSub levelIFstructure {r} = {!   !}
  rightAbsorbSub levelIFstructure {r} = {!   !}

{-
Things that do not hold

hm : {s g adv : Level}
   -> _≤_ levelSemiring s adv
   -> _≤_ levelSemiring (_*R_ levelSemiring g s) adv
hm {.Public} {Public} {.Unused} 0Pub = 0Pub
hm {.Public} {Private} {.Unused} 0Pub = 0Pub
hm {.Public} {Dunno} {.Unused} 0Pub = 0Pub
hm {.Public} {Unused} {.Unused} 0Pub = Refl Unused
hm {.Private} {Public} {.Unused} 0Priv = 0Pub
hm {.Private} {Private} {.Unused} 0Priv = 0Priv
hm {.Private} {Dunno} {.Unused} 0Priv = 0Dunno
hm {.Private} {Unused} {.Unused} 0Priv = Refl Unused
hm {.Public} {Public} {.Private} PrivPub = PrivPub
hm {.Public} {Private} {.Private} PrivPub = PrivPub
hm {.Public} {Dunno} {.Private} PrivPub = PrivPub
-- Public <= Private  (Lo <= Hi)
-- but
-- Public * Unused <= Private
-- Unused <= Private (0 <= Hi)
-- is false as this means Hi [= 0


ohah'' : {r g adv : Level}
    -> _≤_ levelSemiring r adv
    -> _≤_ levelSemiring (_*R_ levelSemiring r g) adv
    -> ¬ _≤_ levelSemiring g adv
    -> ⊥
ohah'' {Private} {Public} {Public} () pre2 npre3
ohah'' {Public} {Private} {Public} (Refl .Public) (Refl .Public) npre3 = npre3 {!!}
ohah'' {a} {b} {c} pre1 pre2 npre3 = {!!}


ohah : {r g adv : Level}
    -> _≤_ levelSemiring r adv
    -> _≤_ levelSemiring (_*R_ levelSemiring r g) adv
    -> _≤_ levelSemiring g adv
-}

check : {s1 s2 adv : Level}
      -> _≤_ levelSemiring s1 adv
      -> _≤_ levelSemiring (_+R_ levelSemiring s1 s2) adv
check {Public} {Public} {Public} (Refl .Public) = Refl Public
check {Public} {Public} {Private} PrivPub = PrivPub
check {Public} {Public} {Dunno} DunnoPub = DunnoPub
check {Public} {Public} {Unused} 0Pub = 0Pub
check {Public} {Private} {Public} (Refl .Public) = Refl Public
check {Public} {Private} {Private} PrivPub = PrivPub
check {Public} {Private} {Dunno} DunnoPub = DunnoPub
check {Public} {Private} {Unused} 0Pub = 0Pub
check {Public} {Dunno} {Public} (Refl .Public) = Refl Public
check {Public} {Dunno} {Private} PrivPub = PrivPub
check {Public} {Dunno} {Dunno} DunnoPub = DunnoPub
check {Public} {Dunno} {Unused} 0Pub = 0Pub
check {Public} {Unused} {Public} (Refl .Public) = Refl Public
check {Public} {Unused} {Private} PrivPub = PrivPub
check {Public} {Unused} {Dunno} DunnoPub = DunnoPub
check {Public} {Unused} {Unused} 0Pub = 0Pub
check {Private} {Public} {Public} ()
check {Private} {Public} {Private} (Refl .Private) = PrivPub
check {Private} {Public} {Dunno} ()
check {Private} {Public} {Unused} 0Priv = 0Pub
check {Private} {Private} {Public} ()
check {Private} {Private} {Private} (Refl .Private) = Refl Private
check {Private} {Private} {Dunno} ()
check {Private} {Private} {Unused} 0Priv = 0Priv
check {Private} {Dunno} {Public} ()
check {Private} {Dunno} {Private} (Refl .Private) = PrivDunno
check {Private} {Dunno} {Dunno} ()
check {Private} {Dunno} {Unused} 0Priv = 0Dunno
check {Private} {Unused} {Public} ()
check {Private} {Unused} {Private} (Refl .Private) = Refl Private
check {Private} {Unused} {Dunno} ()
check {Private} {Unused} {Unused} 0Priv = 0Priv
check {Dunno} {Public} {Public} ()
check {Dunno} {Public} {Private} PrivDunno = PrivPub
check {Dunno} {Public} {Dunno} (Refl .Dunno) = DunnoPub
check {Dunno} {Public} {Unused} 0Dunno = 0Pub
check {Dunno} {Private} {Public} ()
check {Dunno} {Private} {Private} PrivDunno = PrivDunno
check {Dunno} {Private} {Dunno} (Refl .Dunno) = Refl Dunno
check {Dunno} {Private} {Unused} 0Dunno = 0Dunno
check {Dunno} {Dunno} {Public} ()
check {Dunno} {Dunno} {Private} PrivDunno = PrivDunno
check {Dunno} {Dunno} {Dunno} (Refl .Dunno) = Refl Dunno
check {Dunno} {Dunno} {Unused} 0Dunno = 0Dunno
check {Dunno} {Unused} {Public} ()
check {Dunno} {Unused} {Private} PrivDunno = PrivDunno
check {Dunno} {Unused} {Dunno} (Refl .Dunno) = Refl Dunno
check {Dunno} {Unused} {Unused} 0Dunno = 0Dunno
check {Unused} {Public} {Public} ()
check {Unused} {Public} {Private} ()
check {Unused} {Public} {Dunno} ()
check {Unused} {Public} {Unused} (Refl .Unused) = 0Pub
check {Unused} {Private} {Public} ()
check {Unused} {Private} {Private} ()
check {Unused} {Private} {Dunno} ()
check {Unused} {Private} {Unused} (Refl .Unused) = 0Priv
check {Unused} {Dunno} {Public} ()
check {Unused} {Dunno} {Private} ()
check {Unused} {Dunno} {Dunno} ()
check {Unused} {Dunno} {Unused} (Refl .Unused) = 0Dunno
check {Unused} {Unused} {Public} ()
check {Unused} {Unused} {Private} ()
check {Unused} {Unused} {Dunno} ()
check {Unused} {Unused} {Unused} (Refl .Unused) = Refl Unused