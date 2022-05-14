--1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
Result set: model, speed, hd.


SELECT product.model, pc.speed, pc.hd from product
join pc
on product.model = pc.model
where pc.price < 500
