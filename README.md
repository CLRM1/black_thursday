## Black Thursday

The two methods #most_sold_item_for_merchant and #best_item_for_merchant in the sales analyst class are two of the most innovative, complex and industry breaking methods ever written by a group of mod1 students.

`most_sold_item_for_merchant` is a method in the `SalesAnalyst` class designed to return the most sold item by quantity for a given merchant, located in reference to its `merchant_id`. The method takes a single argument of a `merchant_id` as an integer. First we pass the `merchant_id` argument into a helper method called `invoice_items_by_quantity`, which iterates over the `invoice_repository` object to find all invoices that have a matching `merchant_id`. We then iterate over this collection of `invoice` objects to return the corresponding `invoice_item` objects, and create a hash key of the `invoice_item` with a value of its `quantity`. The resulting hash is the return value of this helper method `invoice_items_by_quantity`. Next we sort the hash in the `most_sold_item_for_merchant` method. We then run a `find_all` enumerable on the sorted hash which returns all `invoice_item` objects whose `quantity` matches that of the highest `invoice_item` object. We then map these into an array called `winners` and find the corresponding `item` object for each `invoice_item` object which are collected in an array and returned.







best_item_for_merchant
