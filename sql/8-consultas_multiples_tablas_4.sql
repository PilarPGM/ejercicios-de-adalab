# Ejercicios Consultas Multiples Tablas 4.

# 1. Extraed información de los productos "Beverages"
# En este caso nuestro jefe nos pide que le devolvamos toda la información necesaria para identificar un tipo de producto. 
# En concreto, tienen especial interés por los productos con categoría "Beverages". Devuelve el ID del producto, 
# el nombre del producto y su ID de categoría.

SELECT product_id, product_name, category_id
FROM products
WHERE category_id IN(
	SELECT category_id
    FROM categories
    WHERE category_name = "Beverages");
    

# 2. Extraed la lista de países donde viven los clientes, pero no hay ningún proveedor ubicado en ese país
# Suponemos que si se trata de ofrecer un mejor tiempo de entrega a los clientes, entonces podría dirigirse 
# a estos países para buscar proveedores adicionales.

SELECT DISTINCT country
FROM customers
WHERE country NOT IN(
	SELECT country
    FROM suppliers)
ORDER BY country;

-- Otra posible solución
SELECT country
FROM customers
WHERE country NOT IN(
	SELECT country
    FROM suppliers)
GROUP BY country
ORDER BY country;


# 3. Extraer los clientes que compraron mas de 20 articulos "Grandma's Boysenberry Spread"
# Extraed el OrderId y el nombre del cliente que pidieron más de 20 artículos del producto 
# "Grandma's Boysenberry Spread" (ProductID 6) en un solo pedido.

SELECT orders.order_id, orders.customer_id, customers.company_name
FROM orders
	INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.order_id IN(
	SELECT order_id
	FROM order_details
	WHERE product_id = 6 AND quantity > 20)
ORDER BY orders.order_id;


# 4. Extraed los 10 productos más caros
# Nos siguen pidiendo más queries correlacionadas. En este caso queremos saber cuáles son los 10 productos más caros.

-- Sin subconsulta
SELECT product_name AS `10ProductosMasCaros`, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;

-- Con subconsulta
SELECT product_name AS `10ProductosMasCaros`, unit_price
FROM products
WHERE unit_price > ANY(
	SELECT unit_price
    FROM products)
ORDER BY unit_price DESC
LIMIT 10;


# BONUS
# 1 Qué producto es más popular
# Extraed cuál es el producto que más ha sido comprado y la cantidad que se compró.

SELECT products.product_name, SUM(order_details.quantity) AS CantidadComprada
FROM order_details
	INNER JOIN products ON order_details.product_id = products.product_id
GROUP BY order_details.product_id
ORDER BY CantidadComprada DESC
LIMIT 1;