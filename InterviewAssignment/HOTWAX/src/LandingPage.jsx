import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "./LandingPage.css";

function LandingPage() {
    const [products, setProducts] = useState([]);
    const [search, setSearch] = useState("");
    const [category, setCategory] = useState("all");
    const [cart, setCart] = useState(() => {
        return JSON.parse(localStorage.getItem("cart")) || [];
    });
    const navigate = useNavigate();
    useEffect(() => {
        const fetchProducts = async () => {
            const res = await fetch("https://fakestoreapi.com/products");
            const data = await res.json();
            setProducts(data);
        };
        fetchProducts();
    }, []);
    useEffect(() => {
        localStorage.setItem("cart", JSON.stringify(cart));
    }, [cart]);

    const addToCart = (product) => {
        let qty = prompt("Enter quantity (minimum 1):");
        qty = Number(qty);
        if (!qty || qty < 1) {
            alert("Quantity must be at least 1");
            return;
        }
        const updatedCart = [...cart, { ...product, quantity: qty }
        ];
        setCart(updatedCart);
        localStorage.setItem("cart", JSON.stringify(updatedCart));
    };

    const categoryList = products.map((p) => p.category);
    const uniqueCategories = Array.from(new Set(categoryList));
    const categories = ["all", ...uniqueCategories];

    const filteredProducts = products.filter((product) => {
        const matchesCategory =
            category === "all" || product.category === category;
        const matchesSearch = product.title
            .toLowerCase()
            .includes(search.toLowerCase());
        return matchesCategory && matchesSearch;
    });

    return (
        <div className="products-page">
            <h1>Products</h1>

            <div className="controls">
                <input
                    type="text"
                    placeholder="Search products..."
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                />

                <select value={category} onChange={(e) => setCategory(e.target.value)}>
                    {categories.map((cat) => (
                        <option key={cat} value={cat}>
                            {cat}
                        </option>
                    ))}
                </select>

                <button className="cart-btn" onClick={() => navigate("/cart")}>
                    Show Cart ({cart.length})
                </button>
            </div>
            <div className="products-grid">
                {filteredProducts.map((product) => {
                    const alreadyAdded = cart.some((item) => item.id === product.id);

                    return (
                        <div className="product-card" key={product.id}>
                            <img src={product.image} alt={product.title} />
                            <h3>{product.title}</h3>
                            <p>{product.category}</p>
                            <p>₹ {product.price}</p>

                            <button
                                disabled={alreadyAdded}
                                onClick={() => addToCart(product)}
                            >
                                {alreadyAdded ? "Added" : "Add to Cart"}
                            </button>
                        </div>
                    );
                })}
            </div>
        </div>
    );
}

export default LandingPage;

