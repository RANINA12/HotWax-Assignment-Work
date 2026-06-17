import { Routes, Route } from "react-router-dom";
import { lazy, Suspense } from "react";

import Register from "./Register Page/Register";

const Login = lazy(() => import("./Register Page/Login"));
const Dashboard = lazy(() => import("./LandingPage"));
const Cart = lazy(() => import("./Cart"))
function App() {
  return (

    <Suspense fallback={<div>Loading...</div>}>
      <Routes>
        <Route path="/" element={<Register />} />
        <Route path="/login" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/cart" element={<Cart />} />
      </Routes>
    </Suspense>

  );
}

export default App;
