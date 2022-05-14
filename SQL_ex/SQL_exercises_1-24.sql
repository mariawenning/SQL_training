/* 
The database scheme consists of four tables:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, screen, price)
Printer(code, model, color, type, price)
The Product table contains data on the maker, model number, and type of product ('PC', 'Laptop', or 'Printer'). It is assumed that model numbers in the Product table are unique for all makers and product types. Each personal computer in the PC table is unambiguously identified by a unique code, and is additionally characterized by its model (foreign key referring to the Product table), processor speed (in MHz) – speed field, RAM capacity (in Mb) - ram, hard disk drive capacity (in Gb) – hd, CD-ROM speed (e.g, '4x') - cd, and its price. The Laptop table is similar to the PC table, except that instead of the CD-ROM speed, it contains the screen size (in inches) – screen. For each printer model in the Printer table, its output type (‘y’ for color and ‘n’ for monochrome) – color field, printing technology ('Laser', 'Jet', or 'Matrix') – type, and price are specified.
*/

--1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500. Result set: model, speed, hd.

select product.model, pc.speed, pc.hd 
from product
join pc
on product.model = pc.model
where pc.price < 500

--2. List all printer makers. Result set: maker.

select distinct product.maker 
from product
where type = 'Printer'

--3. Find the model number, RAM and screen size of the laptops with prices over $1000.

select product.model, laptop.ram, laptop.screen
from product
join laptop on product.model = laptop.model
where laptop.price > 1000

--4. Find all records from the Printer table containing data about color printers.

select printer.* 
from printer
where printer.color = 'y'

--5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
 
select pc.model, pc.speed, pc.hd
from pc
where pc.price < 600 and (pc.cd = '12x' or pc.cd = '24x')

--6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.

select product.maker, laptop.speed 
from product
join laptop 
on product.model = laptop.model
where laptop.hd >= 10
group by product.maker, laptop.speed

--7. Get the models and prices for all commercially available products (of any type) produced by maker B.

select pc.model, pc.price
from pc
join product
on pc.model = product.model
where product.maker = 'B'
union
select printer.model, printer.price
from printer
join product
on printer.model = product.model
where product.maker = 'B'
union
select laptop.model, laptop.price
from laptop
join product
on laptop.model = product.model
where product.maker = 'B'

--8. Find the makers producing PCs but not laptops.

select product.maker 
from product
where product.type = 'PC'
except
select product.maker 
from product
where product.type = 'Laptop'

--9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.

select distinct product.maker
from pc
join product
on product.model = pc.model
where pc.speed >=450

--10. Find the printer models having the highest price. Result set: model, price.

select printer.model, printer.price
from printer
where price = (select max(printer.price) from printer)

--11. Find out the average speed of PCs.

select AVG(pc.speed)
from pc

--12. Find out the average speed of the laptops priced over $1000.

select AVG(laptop.speed)
from laptop
where laptop.price > 1000

--13. Find out the average speed of the PCs produced by maker A.

select AVG(pc.speed) 
from pc
join product
on product.model = pc.model
where product.maker = 'A'

--14. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.

select ships.class, name, country
from ships
left join classes
on ships.class = classes.class
where classes.numGuns >= 10

--15. Get hard drive capacities that are identical for two or more PCs. Result set: hd.

select pc.hd
from pc
group by pc.hd
having count(pc.hd) >= 2

--16. Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i). Result set: model with the bigger number, model with the smaller number, speed, and RAM.

select pc1.model, pc2.model, pc1.speed, pc1.ram
from pc as pc1, pc as pc2
where pc1.speed = pc2.speed and pc1.ram = pc2.ram and pc1.model != pc2.model and pc1.model > pc2.model  
group by pc1.model, pc2.model, pc1.speed, pc1.ram

--17. Get the laptop models that have a speed smaller than the speed of any PC. Result set: type, model, speed.

select distinct type, laptop.model, speed
from laptop, product
where laptop.speed < ALL(select speed from pc) and type = 'laptop'

--18. Find the makers of the cheapest color printers. Result set: maker, price.

select distinct product.maker, printer.price
from printer
join product
on product.model = printer.model
where printer.color = 'y' and printer.price = 
(select min(printer.price) 
      from printer where printer.color = 'y')

--19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. Result set: maker, average screen size.

select maker, avg(screen)
from laptop
join product
on product.model = laptop.model
group by maker

--20. Find the makers producing at least three distinct models of PCs. Result set: maker, number of PC models.

select product.maker, count(product.model)
from product
where product.type = 'PC'
group by product.maker
having count(product.model) >= 3

--21. Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.

select maker, max(price)
from product
join pc
on product.model = pc.model
group by maker

--22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds. Result set: speed, average price.

SELECT speed, AVG(price)
from pc
where speed > 600
group by speed

--23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. Result set: maker

select maker
from product
join laptop
on laptop.model = product.model
where laptop.speed >= 750
intersect
select maker
from product
join pc
on pc.model = product.model
where pc.speed >= 750

--24. List the models of any type having the highest price of all products present in the database.

with list1 as (
 select model, max(price) as price1 from pc group by model
 union all
 select model, max(price) as price1 from laptop group by model
 union all
 select model, max(price) as price1 from printer group by model)
select model from list1
where list1.price1 = (select max(price1) from list1)





