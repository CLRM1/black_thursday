## Black Thursday

Welcome to the README for the infamous BLACK THURSDAY project. The contributors for this project are:

- Alex `The Committer` Randolph
- Antonio `Sir .Compact, esq.` Salmeron
- Chris `The Driver` Romero
- James `BigDecimal Energy` Harkins

## Project Description:

This project creates robust, dynamic, innovative tools for complex business analysis and provides a foundation for an e-commerce engine. 

## Notes on the `most_sold_item_for_merchant` and `best_item_for_merchant` Methods

The two methods #most_sold_item_for_merchant and #best_item_for_merchant in the sales analyst class are two of the most innovative, complex and industry breaking methods ever written by a group of mod1 students. Check out our Blog Post below:

`most_sold_item_for_merchant` is a method in the `SalesAnalyst` class designed to return the most sold `item` object by quantity for a given merchant, located in reference to its `merchant_id`. The method takes a single argument of a `merchant_id` as an integer. First we pass the `merchant_id` argument into a helper method called `invoice_items_by_quantity`, which iterates over the `invoice_repository` object to find all invoices that have a matching `merchant_id`. We then iterate over this collection of `invoice` objects to return the corresponding `invoice_item` objects, and create a hash key of the `invoice_item` with a value of its `quantity`. The resulting hash is the return value of this helper method `invoice_items_by_quantity`. Next we sort the hash into an array from highest to lowest quantity in the `most_sold_item_for_merchant` method. We then run a `find_all` enumerable on the sorted hash which returns all `invoice_item` objects whose `quantity` matches that of the highest `invoice_item` object. We then map these into an array called `winners` and find the corresponding `item` object for each `invoice_item` object which are collected in an array and returned.

`best_item_for_merchant` is a method in the `SalesAnalyst` class designed to return the `item` object that generated the greatest revenue for a given merchant. The method takes a single argument of a `merchant_id` as an integer. First we pass the `merchant_id` argument into a helper method called `invoice_items_by_revenue`, which iterates over the `invoice_repository` object to find all invoices that have a matching `merchant_id`. We then iterate over this collection of `invoice` objects, check that they are paid in full by calling the `invoice_paid_in_full?` method with an argument of the currently enumerated invoice's id, and return the corresponding `invoice_item` objects. We then create a hash key of the `invoice_item` with a value of its revenue, which is calculated by multiplying its `unit_price` by its `quantity`. The resulting hash is the return value of this helper method `invoice_items_by_revenue`. Next we sort the hash into an array from highest to lowest revenue in the `best_item_for_merchant` method. We then declare a variable called `winner` and set the value to the `[0]` index of the `[0]` index of the sorted hash, and find the corresponding `item` object for the `invoice_item`.
