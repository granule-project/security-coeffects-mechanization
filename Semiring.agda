module Semiring where

open import Relation.Binary.PropositionalEquality
open import Data.Bool hiding (_≟_; _≤_)
open import Data.Empty
open import Data.Unit hiding (_≟_; _≤_)

record Semiring : Set₁ where
  field
    carrier : Set
    1r      : carrier
    0r      : carrier
    _+R_    : carrier -> carrier -> carrier
    _*R_    : carrier -> carrier -> carrier
    _≤_     : carrier -> carrier -> Set

    leftUnit+   : {r : carrier} -> 0r +R r ≡ r
    rightUnit+  : {r : carrier} -> r +R 0r ≡ r
    comm+       : {r s : carrier} -> r +R s ≡ s +R r

    leftUnit*    : {r : carrier} -> 1r *R r ≡ r
    rightUnit*   : {r : carrier} -> r *R r ≡ r
    leftAbsorb   : {r : carrier} -> r *R 0r ≡ 0r
    rightAbsorb  : {r : carrier} -> 0r *R r ≡ 0r

    assoc*     : {r s t : carrier} -> (r *R s) *R t ≡ r *R (s *R t)
    assoc+     : {r s t : carrier} -> (r +R s) +R t ≡ r +R (s +R t)

    distrib1    : {r s t : carrier} -> r *R (s +R t) ≡ (r *R s) +R (r *R t)
    distrib2    : {r s t : carrier} -> (r +R s) *R t ≡ (r *R s) +R (r *R t)

    monotone*  : {r1 r2 s1 s2 : carrier} -> r1 ≤ r2 -> s1 ≤ s2 -> (r1 *R r2) ≤ (s1 *R s2)
    monotone+  : {r1 r2 s1 s2 : carrier} -> r1 ≤ r2 -> s1 ≤ s2 -> (r1 +R r2) ≤ (s1 +R s2)



open Semiring

-- Level elements
data Level : Set where
  Public  : Level
  Private : Level
  Dunno   : Level
  Unused  : Level

-- constructive representation of the ordering
data Order : Level -> Level -> Set where
  -- central 'line' and its transitivity
  0Pub    : Order Unused Public
  0Priv   : Order Unused Private
  PrivPub : Order Private Public
  -- dunno branch
  0Dunno  : Order Unused Dunno
  PrivDunno : Order Private Dunno
  -- reflexive cases
  Refl : (l : Level) -> Order l l


levelSemiring : Semiring
carrier levelSemiring = Level
1r levelSemiring      = Private
0r levelSemiring      = Unused

_≤_ levelSemiring x y = Order x y

-- unit property
_+R_ levelSemiring Unused x = x
_+R_ levelSemiring x Unused = x
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

assoc* levelSemiring {r} {s} {t} = {!!}

assoc+ levelSemiring {r} {s} {t} = {!!}

distrib1 levelSemiring {r} {s} {t} = {!!}

distrib2 levelSemiring {r} {s} {t} = {!!}

monotone* levelSemiring {.Unused} {.Public} {.Unused} {.Public} 0Pub 0Pub = Refl Unused
monotone* levelSemiring {.Unused} {.Public} {.Unused} {.Private} 0Pub 0Priv = Refl Unused
monotone* levelSemiring {.Unused} {.Public} {.Private} {.Public} 0Pub PrivPub = 0Pub
monotone* levelSemiring {.Unused} {.Public} {.Unused} {.Dunno} 0Pub 0Dunno = Refl Unused
monotone* levelSemiring {.Unused} {.Public} {.Private} {.Dunno} 0Pub PrivDunno = 0Dunno
monotone* levelSemiring {.Unused} {.Public} {.Public} {.Public} 0Pub (Refl Public) = 0Pub
monotone* levelSemiring {.Unused} {.Public} {.Private} {.Private} 0Pub (Refl Private) = 0Priv
monotone* levelSemiring {.Unused} {.Public} {.Dunno} {.Dunno} 0Pub (Refl Dunno) = 0Dunno
monotone* levelSemiring {.Unused} {.Public} {.Unused} {.Unused} 0Pub (Refl Unused) = Refl {!!}
monotone* levelSemiring {.Unused} {.Private} {.Unused} {.Public} 0Priv 0Pub = Refl {!!}
monotone* levelSemiring {.Unused} {.Private} {.Unused} {.Private} 0Priv 0Priv = Refl {!!}
monotone* levelSemiring {.Unused} {.Private} {.Private} {.Public} 0Priv PrivPub = 0Pub
monotone* levelSemiring {.Unused} {.Private} {.Unused} {.Dunno} 0Priv 0Dunno = Refl {!!}
monotone* levelSemiring {.Unused} {.Private} {.Private} {.Dunno} 0Priv PrivDunno = 0Dunno
monotone* levelSemiring {.Unused} {.Private} {s1} {.s1} 0Priv (Refl .s1) = {!!}
monotone* levelSemiring {.Private} {.Public} {.Unused} {.Public} PrivPub 0Pub = {!!}
monotone* levelSemiring {.Private} {.Public} {.Unused} {.Private} PrivPub 0Priv = {!!}
monotone* levelSemiring {.Private} {.Public} {.Private} {.Public} PrivPub PrivPub = {!!}
monotone* levelSemiring {.Private} {.Public} {.Unused} {.Dunno} PrivPub 0Dunno = {!!}
monotone* levelSemiring {.Private} {.Public} {.Private} {.Dunno} PrivPub PrivDunno = {!!}
monotone* levelSemiring {.Private} {.Public} {s1} {.s1} PrivPub (Refl .s1) = {!!}
monotone* levelSemiring {.Unused} {.Dunno} {.Unused} {.Public} 0Dunno 0Pub = {!!}
monotone* levelSemiring {.Unused} {.Dunno} {.Unused} {.Private} 0Dunno 0Priv = {!!}
monotone* levelSemiring {.Unused} {.Dunno} {.Private} {.Public} 0Dunno PrivPub = {!!}
monotone* levelSemiring {.Unused} {.Dunno} {.Unused} {.Dunno} 0Dunno 0Dunno = {!!}
monotone* levelSemiring {.Unused} {.Dunno} {.Private} {.Dunno} 0Dunno PrivDunno = {!!}
monotone* levelSemiring {.Unused} {.Dunno} {s1} {.s1} 0Dunno (Refl .s1) = {!!}
monotone* levelSemiring {.Private} {.Dunno} {.Unused} {.Public} PrivDunno 0Pub = {!!}
monotone* levelSemiring {.Private} {.Dunno} {.Unused} {.Private} PrivDunno 0Priv = {!!}
monotone* levelSemiring {.Private} {.Dunno} {.Private} {.Public} PrivDunno PrivPub = {!!}
monotone* levelSemiring {.Private} {.Dunno} {.Unused} {.Dunno} PrivDunno 0Dunno = {!!}
monotone* levelSemiring {.Private} {.Dunno} {.Private} {.Dunno} PrivDunno PrivDunno = {!!}
monotone* levelSemiring {.Private} {.Dunno} {s1} {.s1} PrivDunno (Refl .s1) = {!!}
monotone* levelSemiring {r1} {.r1} {.Unused} {.Public} (Refl .r1) 0Pub = {!!}
monotone* levelSemiring {r1} {.r1} {.Unused} {.Private} (Refl .r1) 0Priv = {!!}
monotone* levelSemiring {r1} {.r1} {.Private} {.Public} (Refl .r1) PrivPub = {!!}
monotone* levelSemiring {r1} {.r1} {.Unused} {.Dunno} (Refl .r1) 0Dunno = {!!}
monotone* levelSemiring {r1} {.r1} {.Private} {.Dunno} (Refl .r1) PrivDunno = {!!}
monotone* levelSemiring {r1} {.r1} {s1} {.s1} (Refl .r1) (Refl .s1) = {!!}

monotone+ levelSemiring {r1} {r2} {s1} {s2} pre1 pre2 = {!!}


{-
-- Additional property which would be super useful but doesn't seem to hold for Level

infFlow : {levelSemiring : Semiring} -> {r s adv : carrier} -> boolToSet ((r *R s) ≤ adv) -> boolToSet (s ≤ adv)
infFlow levelSemiring {Public} {Public} {Public} prop = tt
infFlow levelSemiring {Public} {Public} {Private} ()
infFlow levelSemiring {Public} {Public} {Dunno} ()
infFlow levelSemiring {Public} {Public} {Unused} ()
--      Public * Private <= Public (yes)
-- (as) Public <= Public
-- but Private <= Public (
infFlow levelSemiring {Public} {Private} {Public} tt = tt
infFlow levelSemiring {Public} {Private} {Private} prop = tt
infFlow levelSemiring {Public} {Private} {Dunno} prop = tt
infFlow levelSemiring {Public} {Private} {Unused} ()
--    Public * Dunno <= Public (yes)
--    Public <= Public
-- but Dunno <= Public is false
infFlow levelSemiring {Public} {Dunno} {Public} tt = {!!}
infFlow levelSemiring {Public} {Dunno} {Private} ()
infFlow levelSemiring {Public} {Dunno} {Dunno} prop = tt
infFlow levelSemiring {Public} {Dunno} {Unused} ()
infFlow levelSemiring {Public} {Unused} {Public} prop = tt
infFlow levelSemiring {Public} {Unused} {Private} prop = tt
infFlow levelSemiring {Public} {Unused} {Dunno} prop = tt
infFlow levelSemiring {Public} {Unused} {Unused} prop = tt
infFlow levelSemiring {Private} {Public} {Public} prop = tt
infFlow levelSemiring {Private} {Public} {Private} ()
infFlow levelSemiring {Private} {Public} {Dunno} ()
infFlow levelSemiring {Private} {Public} {Unused} ()
infFlow levelSemiring {Private} {Private} {Public} tt = tt
infFlow levelSemiring {Private} {Private} {Private} prop = tt
infFlow levelSemiring {Private} {Private} {Dunno} prop = tt
infFlow levelSemiring {Private} {Private} {Unused} ()
infFlow levelSemiring {Private} {Dunno} {Public} ()
infFlow levelSemiring {Private} {Dunno} {Private} ()
infFlow levelSemiring {Private} {Dunno} {Dunno} prop = tt
infFlow levelSemiring {Private} {Dunno} {Unused} ()
infFlow levelSemiring {Private} {Unused} {Public} prop = tt
infFlow levelSemiring {Private} {Unused} {Private} prop = tt
infFlow levelSemiring {Private} {Unused} {Dunno} prop = tt
infFlow levelSemiring {Private} {Unused} {Unused} prop = tt
infFlow levelSemiring {Dunno} {Public} {Public} prop = tt
infFlow levelSemiring {Dunno} {Public} {Private} ()
infFlow levelSemiring {Dunno} {Public} {Dunno} ()
infFlow levelSemiring {Dunno} {Public} {Unused} ()
infFlow levelSemiring {Dunno} {Private} {Public} prop = tt
infFlow levelSemiring {Dunno} {Private} {Private} prop = tt
infFlow levelSemiring {Dunno} {Private} {Dunno} prop = tt
infFlow levelSemiring {Dunno} {Private} {Unused} ()
infFlow levelSemiring {Dunno} {Dunno} {Public} ()
infFlow levelSemiring {Dunno} {Dunno} {Private} ()
infFlow levelSemiring {Dunno} {Dunno} {Dunno} prop = tt
infFlow levelSemiring {Dunno} {Dunno} {Unused} ()
infFlow levelSemiring {Dunno} {Unused} {Public} prop = tt
infFlow levelSemiring {Dunno} {Unused} {Private} prop = tt
infFlow levelSemiring {Dunno} {Unused} {Dunno} prop = tt
infFlow levelSemiring {Dunno} {Unused} {Unused} prop = tt
infFlow levelSemiring {Unused} {Public} {Public} prop = tt
infFlow levelSemiring {Unused} {Public} {Private} tt = {!!}
infFlow levelSemiring {Unused} {Public} {Dunno} tt = {!!}
infFlow levelSemiring {Unused} {Public} {Unused} tt = {!!}
infFlow levelSemiring {Unused} {Private} {Public} tt = tt
infFlow levelSemiring {Unused} {Private} {Private} prop = tt
infFlow levelSemiring {Unused} {Private} {Dunno} prop = tt
infFlow levelSemiring {Unused} {Private} {Unused} tt = {!!}
infFlow levelSemiring {Unused} {Dunno} {Public} tt = {!!}
infFlow levelSemiring {Unused} {Dunno} {Private} tt = {!!}
infFlow levelSemiring {Unused} {Dunno} {Dunno} prop = tt
infFlow levelSemiring {Unused} {Dunno} {Unused} tt = {!!}
infFlow levelSemiring {Unused} {Unused} {Public} prop = tt
infFlow levelSemiring {Unused} {Unused} {Private} prop = tt
infFlow levelSemiring {Unused} {Unused} {Dunno} prop = tt
infFlow levelSemiring {Unused} {Unused} {Unused} prop = tt
-}
