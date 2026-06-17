import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "./Cart.css";

function Cart() {
    const [cart, setCart] = useState([]);
    const navigate = useNavigate();
    useEffect(() => {
        const storedCart = JSON.parse(localStorage.getItem("cart")) || [];
        setCart(storedCart);
    }, []);

    const handleremove = (id) => {
        const updatedCart = cart.filter(item => item.id !== id);
        setCart(updatedCart);
        localStorage.setItem("cart", JSON.stringify(updatedCart));
    };

    const minusQuantity = (id) => {
        const updatedCart = cart.map(item => item.id === id ? { ...item, quantity: item.quantity - 1 } : item).filter(item => item.quantity > 0);
        setCart(updatedCart);
        localStorage.setItem("cart", JSON.stringify(updatedCart));
    }
    const plusQuantity = (id) => {
        const updatedCart = cart.map(item => item.id === id ? { ...item, quantity: item.quantity + 1 } : item);
        setCart(updatedCart);
        localStorage.setItem("cart", JSON.stringify(updatedCart));
    };


    return (
        <div className="cart-page">
            <button className="back-button" onClick={() => navigate("/dashboard")}>
                Back
            </button>

            <h1>Cart</h1>

            {cart.length === 0 && <p>Cart is empty</p>}

            <div className="cart-grid">
                {cart.map((item) => (
                    <div className="cart-card" key={item.id}>
                        <img src={item.image} alt={item.title} />
                        <h4>{item.title}</h4>
                        <p>₹ {item.price}</p>
                        <div>
                            <button onClick={() => minusQuantity(item.id)}>-</button>
                            <p>Total quantity : {item.quantity}</p>
                            <button onClick={() => plusQuantity(item.id)}>+</button>
                        </div>

                        <button onClick={() => handleremove(item.id)}>
                            Remove Item
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default Cart;
