-- Saddleback.hs
-- Copyright (C) 2013 Liu Xinyu (liuxinyu95@gmail.com)
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

-- Saddleback search based on Chapter 3 of [1]
-- [1] Richard Bird. ``Pearls of functional algorithm design''. Cambridge University Press. 2010. ISBN, 1139490605, 9781139490603

import Test.QuickCheck
import Data.List (sort)

-- brute-force naive search
-- In order to test easily, the brute force search actually starts from top-left corner, so that
--   It finds the solution in the same order as saddleback search.
bruteSolve f z = [(x, y) | x <- [0..z], y<- [z, z-1..0], f x y == z]

-- Saddleback basic version based on [2]
-- [2] Edsger W. Dijkstra. ``The saddleback search''. EWD-934. 1985. http://www.cs.utexas.edu/users/EWD/index09xx.html.
solve f z = search 0 z where
  search p q | p > z || q < 0 = []
             | z' < z = search (p + 1) q
             | z' > z = search p (q - 1)
             | otherwise = (p, q) : search (p + 1) (q - 1)
    where z' = f p q
                           
-- Minor improvement by using binary search to find the more accurate boundaries
-- Binary search in range (l, u)
bsearch f y (l, u) | u <= l = l
                   | f m <= y = bsearch f y (m + 1, u)
                   | otherwise = bsearch f y (l, m)
  where m = (l + u) `div` 2
        
solve' f z = search 0 m where
  search p q | p > n || q < 0 = []
             | z' < z = search (p + 1) q
             | z' > z = search p (q - 1)
             | otherwise = (p, q) : search (p + 1) (q - 1)
    where z' = f p q
  m = bsearch (f 0) z (0, z)
  n = bsearch (\x->f x 0) z (0, z)

-- test
fs = [\x y -> x + y, \x y -> 2^x + 3^y, \x y -> x^2 + y^2]

prop_solve :: Integer -> Bool
prop_solve z = let z' = abs z `mod` 100 in and $ map (\f -> solve f z' == bruteSolve f z') fs

prop_solve' :: Integer -> Bool
prop_solve' z = let z' = abs z `mod` 100 in and $ map (\f -> solve' f z' == solve f z') fs