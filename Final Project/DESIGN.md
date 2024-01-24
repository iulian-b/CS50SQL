


# Design Document



![Logo](https://i.imgur.com/USUl8J1.png)



By Iulian Ionel Bocșe



Video overview: <https://www.youtube.com/watch?v=Xf8Owrhsq0s>



## Scope



The database PCShop includes entities necessary to facilitate the process of tracking and selling high end custom built computers for an online computers shop. The shop's administrator can view and add components, computers, and view orders and order details. Customers, meanwhile, can view computers and place orders.

Included in this database's scope is:



*  *CPU*s, *GPU*s, *PSU*s and *Motherboards* (which are all core computer components) and their respective specifications, and information such as release date and price;

*  *Computers*, including a name, storage size, ram and the parts that they're made of;

*  *Customers*, including basic identifying information;

*  *Orders* and *Order Item*, which store the information related to orders made by customers



As per any online computers retailer, this PC shop adds an "assembly fee" of $24.99 per computer (24.99 is an arbitrary number chosen as an example for this project).



The schema.sql file already includes some INSERT queries which automatically populate the database's tables with some data. This data was acquired manually by me, from the various manufacturers websites (intel.com, amd.com, etc.).



Out of scope are elements like customer credentials (password, username, email, etc.).

Also, while other computer components (hard drives, SSDs, RAM, network cars, etc.) could've been included in the schema, and have their own table, i decided to not include them and simplify a computer down to 4 main parts.





## Functional Requirements



A database user should be able to:



#### PCShop administrator user



* View all available components (CPU/GPU/PSU/Motherboard);

* Add a new component;

* Alter the component's price;

* View, Add or remove a computer;

* View orders and customer information;



#### Customer user



* View all available computers and their respective prices;

* List a computer's specifications;

* List a computer's specifications regarding a particular component (gpu, cpu, etc.);



## Representation



### Entities

The database includes the following entities:



#### CPUs (Central Processing Unit)

The `cpus` table includes:

*  `id`: specifies the unique ID for the CPU as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

*  `model`: the CPU's model name as `TEXT`, given `TEXT` is appropriate for name fields.

*  `manufacturer`: CPU's manufacturer. `TEXT` is used for the same reason as `model`.

*  `release_date`: specifies in which year the CPU was released. `INTEGER` is used because this column stores only the year number, and as such, `NUMERIC` was not needed.

*  `price`: the CPU's retail price using `REAL`, which allows the inclusion of decimal numbers.

*  `cores`: the number of CPU cores. `INTEGER` was used in this case, and a constraint of `CHECK("cores" % 2 = 0)` was added to check if the core numbers are divisible by 2.

*  `threads`: similar to `cores`, it stores the CPU's number of threads as an `INTEGER` that is divisible by 2 (`CHECK("threads" % 2 = 0)`). On top of this, threads numbers cannot be lower that the number of cores on a processor, so another check `CHECK("threads" > "cores")` was added to prevent incorrect data from being inserted.

*  `base_frequency`: the frequency at which the CPU runs at. It's stored as a `REAL` because CPU frequency is in Giga Hertz (GHz).

*  `turbo_frequency`: the frequency at which the CPU "boosts" in high load operations. It uses `REAL` for the same reasons as `base_frequency`.

*  `cache`: the number of the L2 cache size of the CPU. `INTEGER` was used to represent this number as most consumer CPUs have cache in Mega Bytes (MB), which are whole numbers. A constraint of `CHECK("cache" > 0)` was added to prevent the insertion of cache-less CPUs.



All columns besides `released_date` and `turbo_frequency` are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` constraint is not.



#### GPUs (Graphical Processing Unit)

The `gpus` table includes:

*  `id`: specifies the unique ID for the GPU as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

*  `model`: the GPU's model name as `TEXT`, given `TEXT` is appropriate for name fields.

*  `manufacturer`: GPU's manufacturer. `TEXT` is used for the same reason as `model`.

*  `release_date`: specifies in which year the GPU was released. `INTEGER` is used because this column stores only the year number, and as such, `NUMERIC` was not needed.

*  `price`: the GPU's retail price using `REAL`, which allows the inclusion of decimal numbers.

*  `cores`: the number of GPU cores. `INTEGER` was used in this case as GPU cores are whole numbers.

*  `memory`: the size of the GPU's GDDR on-board memory (also known as "V-RAM"). `INTEGER` was used in this case as GPU memory sizes are whole numbers.

*  `membus`: the width of the GPU's memory bus (also known as "memory bandwidth"). Stored as a an `INTEGER` for same reasons as `memory`.

*  `tflops`: the theoretical performance of a GPU, also known as "Tera Flops" (or tflops for short). It uses `REAL` because teraflops numbers, more often than not, have decimals.

*  `tbp`: short for "Typical Board Power", is the number of Watts (W) which the GPU needs to run. This information is useful for choosing an appropriate Power Supply that can provide such wattage. As TBP numbers are almost always whole numbers, `INTEGER` was used here as well.



All columns besides `released_date` and `tflops` are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` constraint is not.



#### PSUs (Power Supply Unit)

The `gpus` table includes:

*  `id`: specifies the unique ID for the PSU as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

*  `model`: the PSU's model name as `TEXT`, given `TEXT` is appropriate for name fields.

*  `manufacturer`: PSU's manufacturer. `TEXT` is used for the same reason as `model`.

*  `release_date`: specifies in which year the PSU was released. `INTEGER` is used because this column stores only the year number, and as such, `NUMERIC` was not needed.

*  `price`: the PSU's retail price using `REAL`, which allows the inclusion of decimal numbers.

*  `output`: the number of Watts (W) the PSU outputs. `INTEGER` was used in this case for the same reasons `tbp` in the `gpus` table.

*  `efficency`: the [80 Plus Efficiency rating](https://www.velocitymicro.com/blog/what-is-psu-efficiency-and-why-is-it-important/) of the PSU. Unlike many other ratings, this one is not numeric. It ranges from "80 PLUS Bronze" (worst) to "80 PLUS Titanium" (best). The rating of "80 PLUS" (without a metal name) also exists, for PSUs that fail to achieve Bronze but that have been rated. 'None' is also included as a choice, for unrated PSUs.

As such, `TEXT` was used because this column required a string, and the following constraint was added: `CHECK("efficency" IN('None','80 PLUS','80 PLUS Bronze','80 PLUS Silver','80 PLUS Gold','80 PLUS Platinum','80 PLUS Titanium'))` and `DEFAULT('None')`.

*  `form_factor`: the form factor of the PSU. `TEXT` was used in this case.

*  `modularity`: the modularity of the PSU, which can either be 'Fully-modular', 'Semi-modular' or none. Because it required a string of text, the type `TEXT` was used and the constraint `CHECK("modularity" IN('None','Semi','Full')) DEFAULT('None')` was added.



All columns besides `released_date`, `efficency` and `modularity` are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` constraint is not. `efficency` and `modularity` also include a `DEFAULT` value of `None`, which allows the insertion of a PSU without specifying the `efficency` and/or `modularity` values, without breaking their constraints.



#### Mobos (Motherboards)

The `mobos` table includes:

*  `id`: specifies the unique ID for the Motherboard as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

*  `model`: the Motherboard's model name as `TEXT`, given `TEXT` is appropriate for name fields.

*  `manufacturer`: Motherboard's manufacturer. `TEXT` is used for the same reason as `model`.

*  `release_date`: specifies in which year the Motherboard was released. `INTEGER` is used because this column stores only the year number, and as such, `NUMERIC` was not needed.

*  `price`: the Motherboard's retail price using `REAL`, which allows the inclusion of decimal numbers.

*  `socket`: the type of [CPU Socket](https://en.wikipedia.org/wiki/CPU_socket) used on the Motherboard, using `TEXT`. A socket determines the type of CPUs that can be installed on a Motherboard. In this database, only 3 types of socket are used, so the constraint `CHECK("socket" IN('AM4','LGA1700','LGA1200'))` checks for that, but many more exist.

*  `form_factor`: the form factor of the Motherboard. `TEXT` was used here as well, and a constraint of `CHECK("form_factor" IN('ATX','E-ATX','mATX','ITX'))` was added to cover all of the commonly used ATX form factors.

*  `chipset`: the chipsed used on the Motherboard. `TEXT`type was the most appropriate for this field, as it stores the chipset's name.

*  `wifi`: a Boolean stored using the `TEXT` type ('yes' or 'no'), used to determine if the Motherboard has an on-board WiFi chip. The constraint added to this column is: `CHECK("wifi" IN('yes','no')) DEFAULT('no')`



All columns besides `released_date` and `wifi` are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` constraint is not. `wifi` includes a `DEFAULT` value of `None`, which allows the insertion of a Motherboard without specifying the `wifi` value, without breaking the constraint.



#### Computers

The `computers` table includes:

*  `id`: specifies the unique ID for the computer as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

*  `name`: the computer's name as `TEXT`, given `TEXT` is appropriate for name fields.

*  `storage`: the computer's storage size in Terabytes (TB). `REAL` is used in this case, as computers can include less than 1 terabyte storage drives (NVMes and such). This column is checked for `CHECK("quantity" > 0.00)`, as selling a computer without storage (or less than 0) makes no sense.

*  `ram`: similar to the `storage` field but with RAM sizes, although the type `INTEGER` was used in this case, because RAM sticks with less than 1GB of memory are not used anymore in present day computers, and even less in the high-end computers seen in this database. The check `CHECK("quantity" > 0)` verifies a computer has a positive amount of RAM.

*  `cpu`: the is the ID of the CPU used in the computer as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `cpus` table to ensure data integrity.

*  `gpu`: the is the ID of the GPU used in the computer as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `gpus` table to ensure data integrity.

*  `psu`: the is the ID of the PSU used in the computer as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `psus` table to ensure data integrity.

*  `mobo`: the is the ID of the Motherboard used in the computer as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `mobos` table to ensure data integrity.



All columns in the `computers` table are required and hence should have the `NOT NULL` constraint applied.



#### Customers

The `customers` table includes:

*  `id`: specifies the unique ID for the customer as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

*  `first_name`: the customer's first name as `TEXT`, given `TEXT` is appropriate for name fields.

*  `last_name`: the customer's last name. `TEXT` is used for the same reason as `first_name`.



All columns in the `customers` table are required, and hence should have the `NOT NULL` constraint applied. No other constraints are necessary.



#### Orders

The `orders` table includes:

*  `id`: specifies the unique ID for the order as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

*  `customer_id`: the ID of the customer who placed the order as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `customers` table to ensure data integrity.

*  `timestamp`: specifies when the customer placed the order. Timestamps in SQLite can be conveniently stored as `NUMERIC`. The default value for the `timestamp` attribute is the current timestamp, as denoted by `DEFAULT CURRENT_TIMESTAMP`.

*  `address`: the address at which the ordered items are meant to be shipped to, stored as a `TEXT` value.



All columns in the `orders` table are required, and hence should have the `NOT NULL` constraint applied. No other constraints are necessary.



#### Order Items

The `order_itmes` table includes:

*  `order_id`: specifies the ID for the order as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `orders` table to ensure data integrity, but also the `PRIMARY KEY` constraint with the `computer_id` column: `PRIMARY KEY("order_id","computer_id")`.

*  `computer_id`: specifies the ID for the computer as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `computers` table to ensure data integrity, but also the `PRIMARY KEY` constraint with the `order_id` column: `PRIMARY KEY("order_id","computer_id")`.

*  `quantity`: the quantity of the specified computer (`computer_id`) that was bought by the customer (`customer_id`). Given it's use, the `INTEGER` type was used.


All columns in the `order_items` table are required, and hence should have the `NOT NULL` constraint applied. A constraint on `quantity` was added to prevent buying a negative or zero amount of computers: `CHECK("quantity" > 0)`



### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.



![E:R diagram](https://i.imgur.com/s0tMeAe.png)



As detailed by the diagram:

* One **customer** is capable of placing many **orders**. An **order** is placed by one and only one **customer**.

* An **order** can include 1 or more **order items**. Many **order items** can be associated with the same **order**, in the case that one **customer** decides to order 2 or more different **computers** in the same **order**.

* An **order item** contains one and only one **computer**. A **computer** can be in 0 or more **order items**. 0 if the **computer** has yet to be bought by a customer, and many if more than one customer has bought that same computer.

* A **computer**, to exist, it must contain one **CPU**, one **GPU**, one **PSU** and one **MOBO**. It cannot contain more than 1 of the previously aforementioned components, nor can it contain 0 of them.

* Any **CPU**, **GPU**,**PSU** and **MOBO** can be present in 0 or more **computers**. 0 if that specific component was not used in a computer yet, and many if more computers use the same component.



## Optimizations



### Views

#### Computers Prices

The view `computers_prices` shows all available computers in the shop and their respective price. Note that the 24.99 assembly fee is included in the price displayed by this view.



![Computer Prices View](https://i.imgur.com/HxEyfXk.png)



This view can be used with a `SELECT` query to, for example, view the price of only 1 specific computer:



~~~

SELECT * FROM "computers_prices"

WHERE "Name" = 'Green Devil';

~~~



Another use it to search for computer based on a price range or budget: if a customer has a budget of 2000 USD, he might look at all available computers under that price with this query:



~~~

SELECT * FROM "computers_prices"

WHERE "Price (USD)" <= 2000;

~~~



#### Computers Specs

The view `computers_specs` is a more detailed `computers_prices` and shows all available computers in the shop and their respective specifications.

`Processor`, `Graphics Card`, `Power Supply` and `Motherboard` are composed of the `manufacturer` + `model` columns of each of their respective table.

Much like in `computers_prices`, the `Price (USD)` column in this view includes the assembly fee.



![Computer Specs View](https://i.imgur.com/rqXkcs7.png)



This view can be used with a `SELECT` query to, for example, search for computers that use a specific component:



~~~

SELECT * FROM "computers_specs"

WHERE "Graphics Card" LIKE '%RTX 4090';

~~~



#### Computers CPU Details

The view `computers_cpu_details` shows all available computers in the shop and all of the useful information related to their installed CPU.



![CPU Details View](https://i.imgur.com/w8Rplsm.png)



This view can be used with a `SELECT` query to, for example, search for computers that use a specific CPU brand, model or to search by release date, cores, threads, etc.

Example: Select all computer's which have the newest (2023) Intel CPUs:



~~~

SELECT * FROM "computers_cpu_details"

WHERE "Brand" = 'Intel'

AND "Released In" = 2023;

~~~



#### Computers GPU Details

The view `computers_gpu_details` shows all available computers in the shop and all of the useful information related to their installed GPU.



![GPU Details View](https://i.imgur.com/wAEEhWb.png)



Use cases for this view are similar to `computers_cpu_details`: searching by brand, model, release year, specifications, or a mix of the aforementioned.



#### Computers PSU Details

The view `computers_psu_details` shows all available computers in the shop and all of the useful information related to their installed GPU.



![PSU Details View](https://i.imgur.com/a9mtyM6.png)



Use cases for this view are similar to `computers_cpu_details`: searching by brand, model, release year, specifications, or a mix of the aforementioned.



#### Computers Motherboard Details

The view `computers_mobo_details` shows all available computers in the shop and all of the useful information related to their installed GPU.



![MOBO Details View](https://i.imgur.com/Af3IQej.png)



Use cases for this view are similar to `computers_cpu_details`: searching by brand, model, release year, specifications, or a mix of the aforementioned.



#### All Orders

The view `all_orders` shows all orders and information regarding the orders.



![All Orders View](https://i.imgur.com/A2r4etV.png)



This is a rudimentary view of the orders, meant to be used speed up the process of listing orders, instead of using a query each time.



#### All Orders Details

The view `all_orders_details` shows all orders and all items ordered.



![All Order Details](https://i.imgur.com/02k6mKe.png)



Much like `all_orders`, this view is meant to speed up the process of listing orders. But unlike `all_orders`, `all_order_details` shows more in-depth information about orders, such as:

* What computers were bought

* The quantity

* The total price of the order (without assembly fee)

* The total price of the assembly fee (24.99 * Nr of computers)

* A timestamp, instead of a date



The most common use case for this view is to list all items bought in one order:



~~~

SELECT * FROM "all_oder_details" WHERE "Order Nr." = 4;

~~~



Other common cases might include, searching orders by first name or last name, by date, by address or by items.



### Indexes

It is common for users of the database to search for a specific component's specifications. For that reason, indexes are created on the `manufacturer` and `model` columns for each component type table, to speed up the process:

~~~

CREATE INDEX "cpu_index" ON "cpus"("manufacturer","model");

CREATE INDEX "gpu_index" ON "gpus"("manufacturer","model");

CREATE INDEX "psu_index" ON "psus"("manufacturer","model");

CREATE INDEX "mobo_index" ON "mobos"("manufacturer","model");

~~~

Similarly, the same thing was done for speeding up the search of customers, by indexing the `first_name` and `last_name` columns of the `customers` table:



~~~

CREATE INDEX "customers_index" ON "customers"("first_name","last_name");

~~~



## Limitations



1. The current schema assumes that customers and the database administrators are two different types of users, who both have different use cases of the database. While SQLite3 does not support *users* or *authentication* to a database, we can only assume that the database is used in unison with another programming language like PHP, Python or Javascript:
Ex. when a customer goes on the shop's website and click on "all products", a query (`SELECT * FROM "computers_prices";`) is used by PHP to interact with *pcshop.db* and retrieve the list of computers, which can then be displayed on the HTML page that the end user sees.



2. As stated in the Scope of this document, this schema includes only 4 types of components to describe a PC. This is done for simplicity, but more tables such as RAM or Storage could be theoretically added.



3. The Motherboards table `mobos` contains a column named `socket` which specifies the type of socket that is present on the board. This socket determines which CPUs can be installed on it, for example, a motherboard with an AM4 socket can only accept AM4 CPUs (AMD) and not LGA ones (Intel).
This means that there should be a constraint somewhere to prevent the insertion of a pc into the `computers` table, where its motherboard and CPU would be physically incompatible. This aspect is not handled by the current schema, and is left to the database user.
Logically speaking, one would not add a computer which cannot be assembled into a list of products he intends to sell, but practically speaking, such case *can* happen.
