<%--
  Created by IntelliJ IDEA.
  User: oliva
  Date: 7/04/2026
  Time: 21:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Desarrollo web Integrado - Proyecto</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .wrapper {
            text-align: center;
            padding: 3rem 2rem;
            max-width: 560px;
            width: 90%;
            animation: fadeUp .6s ease;
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .icon-box {
            width: 56px;
            height: 56px;
            background: #e8f0fe;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }

        h1 {
            font-size: 2rem;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: .5rem;
        }

        h1 span {
            color: #3b82f6;
        }

        .subtitle {
            color: #718096;
            font-size: 1rem;
            line-height: 1.7;
            margin-bottom: 2rem;
        }

        .buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-bottom: 2.5rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 11px 30px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all .2s;
            border: 1px solid;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }

        .btn-primary:hover {
            background: #2563eb;
        }

        .btn-secondary {
            background: white;
            color: #4a5568;
            border-color: #e2e8f0;
        }

        .btn-secondary:hover {
            background: #f7fafc;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1rem;
            text-align: left;
            transition: all .2s;
        }

        .card:hover {
            border-color: #cbd5e0;
            transform: translateY(-2px);
        }

        .card-icon {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: .6rem;
            font-size: 16px;
        }

        .card h3 {
            font-size: 13px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 3px;
        }

        .card p {
            font-size: 12px;
            color: #718096;
            line-height: 1.5;
        }

        .footer {
            margin-top: 2rem;
            font-size: 12px;
            color: #a0aec0;
        }
    </style>
</head>
<body>
<div class="wrapper">

    <div class="icon-box">
        <svg width="24" height="24" fill="none" stroke="#3b82f6" stroke-width="2"
             stroke-linecap="round" viewBox="0 0 24 24">
            <polyline points="16 18 22 12 16 6"/>
            <polyline points="8 6 2 12 8 18"/>
        </svg>
    </div>

    <h1>Bienvenido a <span>MiApp</span></h1>
    <p class="subtitle">Tu plataforma Java EE está lista.<br>Gestiona tus datos de forma fácil y segura.</p>

    <div class="buttons">
        <a href="login.jsp" class="btn btn-primary">Iniciar sesión</a>
        <a href="registro.jsp" class="btn btn-secondary">Registrarse</a>
    </div>

    <div class="cards">
        <div class="card">
            <div class="card-icon" style="background:#f0fff4;">🛡️</div>
            <h3>Seguro</h3>
            <p>Sesiones y autenticación</p>
        </div>
        <div class="card">
            <div class="card-icon" style="background:#ebf8ff;">🗄️</div>
            <h3>Base de datos</h3>
            <p>Conexión con DAO</p>
        </div>
        <div class="card">
            <div class="card-icon" style="background:#fffbeb;">📦</div>
            <h3>Modular</h3>
            <p>Estructura MVC</p>
        </div>
    </div>

    <p class="footer">Java EE + Tomcat — 2026</p>

</div>

</body>
</html>
