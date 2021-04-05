# Knot
Geometrical pattern design thing. 

Knot isn't the original name. It was named 'Girih', a type of geometric design found in Islamic architecture which means knot.
It uses N-gons symetrically to draw patterns
There are options to fill the polygons, vertex count, polycount, rotation etc

4 parts in code:
1. Knot  -- handles almost all the I/O and drawing logic
2. Ngon -- Container for polygons. acts as a parent for basic elements like penta or hexagons.
3. Gon -- elementary polygons.
4.BIOS -- I/O helper for Knot. Just reduces piles of code in Knot. Nothing special

Well that's all. 
