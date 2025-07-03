
import tkinter as tk
from tkinter import messagebox
# ------------------- Pizza Data -------------------

pizza_prices = {
    "Margherita": 150,
    "Pepperoni": 200,
    "Veggie": 180
}

size_prices = {
    "Small": 0,
    "Medium": 50,
    "Large": 100
}

topping_prices = {
    "Extra Cheese": 30,
    "Olives": 20,
    "Jalapenos": 25
}


root = tk.Tk()
root.title("Pizza Order System")
root.geometry("700x500")

selected_pizza = tk.StringVar(value="Margherita")
selected_size = tk.StringVar(value="Small")
selected_topping = tk.StringVar(value="Extra Cheese")
quantity_var = tk.IntVar(value=1)

# ------------------- Left Frame - Selections -------------------

left_frame = tk.Frame(root, padx=10, pady=20)
left_frame.pack(side="left", fill="y")

tk.Label(left_frame, text="Select Pizza Type", font=('Arial', 12, 'bold')).pack(anchor="center")
for pizza in pizza_prices.keys():
    tk.Radiobutton(left_frame, text=pizza, variable=selected_pizza, value=pizza).pack(anchor="w")

tk.Label(left_frame, text="\nSelect Size", font=('Arial', 12, 'bold')).pack(anchor="w")
for size in size_prices.keys():
    tk.Radiobutton(left_frame, text=size, variable=selected_size, value=size).pack(anchor="w")

tk.Label(left_frame, text="\nSelect Topping", font=('Arial', 12, 'bold')).pack(anchor="w")
for topping in topping_prices.keys():
    tk.Radiobutton(left_frame, text=topping, variable=selected_topping, value=topping).pack(anchor="w")

tk.Label(left_frame, text="\nQuantity", font=('Arial', 12, 'bold')).pack(anchor="w")
tk.Spinbox(left_frame, from_=1, to=10, textvariable=quantity_var, width=5).pack(anchor="w")

# ------------------- Right Frame - Menu -------------------

right_frame = tk.Frame(root, padx=20, pady=20)
right_frame.pack(side="right", fill="both", expand=True)

tk.Label(right_frame, text="Pizza Menu", font=('Arial', 14, 'bold')).pack()

menu_text = "\n".join([
    f"{pizza}: ₹{price}" for pizza, price in pizza_prices.items()
]) + "\n\nSizes: \n" + "\n".join([
    f"{size} (+₹{price})" for size, price in size_prices.items()
]) + "\n\nToppings:\n" + "\n".join([
    f"{top} (+₹{price})" for top, price in topping_prices.items()
])

menu_label = tk.Label(right_frame, text=menu_text, font=('Arial', 11))
menu_label.pack(anchor="center")

# ------------------- Checkout Logic -------------------

def checkout():
    pizza = selected_pizza.get()
    size = selected_size.get()
    topping = selected_topping.get()
    quantity = quantity_var.get()

    base_price = pizza_prices[pizza]
    size_cost = size_prices[size]
    topping_cost = topping_prices[topping]

    total_per_pizza = base_price + size_cost + topping_cost
    total_cost = total_per_pizza * quantity

    summary = (
        f"Your Order Summary:\n\n"
        f"Pizza: {pizza} - ₹{base_price}\n"
        f"Size: {size} (+₹{size_cost})\n"
        f"Topping: {topping} (+₹{topping_cost})\n"
        f"Quantity: {quantity}\n\n"
        f"Total Amount: ₹{total_cost}"
    )
    messagebox.showinfo("Order Summary", summary)

# ------------------- Checkout Button -------------------

checkout_btn = tk.Button(root, text="Checkout", command=checkout, font=('Arial', 12, 'bold'), bg="green", fg="white")
checkout_btn.pack(side="bottom", pady=20)

root.mainloop()

