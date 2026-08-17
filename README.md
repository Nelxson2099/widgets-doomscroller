# 💀 DoomScroller - Suite de Widgets para Rainmeter (Windows PC)

[![Rainmeter Compatible](https://img.shields.io/badge/Rainmeter-4.5%2B-7C3AED?style=for-the-badge&logo=windows&logoColor=white)](https://www.rainmeter.net/)
[![Design: Dark Glass](https://img.shields.io/badge/Design-Dark%20Glassmorphic-38BDF8?style=for-the-badge)](https://obsidian.md/)
[![License: MIT](https://img.shields.io/badge/License-MIT-10B981?style=for-the-badge)](LICENSE)

> **Suite minimalista de alto rendimiento para Windows PC con estética Dark Glassmorphic, acentos Neón Purple / RGB Chroma y consumo de recursos ultra-bajo (< 0.1% CPU / RAM).**

---

## 🌟 Módulos y Widgets Incluidos (10 Módulos)

### 1. 🌤️ Clima Open-Meteo (`Weather/DoomScrollerWeather.ini`)
- **Meteorología en Vivo**: Integración sin API Keys con **Open-Meteo API** (Coordenadas predeterminadas de Caracas: `10.48°N, -66.90°W`, totalmente personalizable).
- **Pronóstico de Hoy y Mañana**:
  - **Hoy**: Temperatura actual, sensación térmica, velocidad del viento (km/h), humedad %, condición meteorológica y rango Máx/Mín.
  - **Mañana**: Pronóstico de 24 horas, rango térmico y probabilidad visual de lluvia %.
- **Modo Offline**: Respaldo automático si la conexión a internet falla.

### 2. 🌙 Fase Lunar Astronómica (`Moon/DoomScrollerMoon.ini`)
- **Esfera Lunar Dinámica**: Cálculo astronómico de precisión en tiempo real de la fase lunar actual (Luna Nueva, Creciente, Llena, Menguante).
- **Iluminación %**: Iluminación gráfica central ajustada dinámicamente.
- **Próximo Hito**: Cuenta regresiva en días hacia el próximo cambio de fase principal.

### 3. 🧬 Reloj Circadiano Biométrico (`Circadian/DoomScrollerCircadian.ini`)
- **Rastreo Biológico**: Seguimiento de 6 métricas y hormonas circadianas principales (Cortisol, Melatonina, Presión de Sueño, Hormona de Crecimiento, Temperatura Corporal y Sensibilidad a la Insulina).
- **Ventana Biológica Activa**: Notifica el estado actual del cuerpo (ej. *Pico de Testosterona*, *Ventana Proteica*, *Ascenso de Melatonina*).

### 4. ⏳ Memento Mori (`Memento/DoomScrollerMemento.ini`)
- **Conciencia del Tiempo**: Muestra días vividos, semanas transcurridas, número de semana del año (1-52) y barra de progreso de expectativa de vida configurable.

### 5. ✅ Habit Flow (`Habits/DoomScrollerHabits.ini`)
- **Rastreador de Hábitos en Escritorio**: Panel interactivo con interruptores visuales para marcar tus objetivos diarios (*Meditar*, *Leer*, *Tomar Sol*, *Ejercicio*, *Crear*) directamente desde el escritorio.

### 6. 🎵 Audio Visualizer RGB (`Visualizer/DoomScrollerAudioPlayer.ini`)
- **Espectro Reactivo**: Espectro de ondas de audio en tiempo real reactivo al sonido de tu PC con soporte para **Modo RGB Chroma**.

### 7. 📅 Mini Calendario (`Calendar/DoomScrollerCalendar.ini`)
- **Matriz Mensual Interactiva**: Visualizador de fecha en vivo con matriz completa de días del mes, número de semana y botones de navegación (`◄`, `►` y `[HOY]`).

### 8. 🍅 Temporizador Pomodoro (`Pomodoro/DoomScrollerPomodoro.ini`)
- **Enfoque & Descanso**: Temporizador Pomodoro de escritorio para ciclos de trabajo de 25m y descansos de 5m.

### 9. 🌍 Reloj UTC (`UTC/DoomScrollerUTC.ini`)
- **Huso Horario Global**: Muestra la hora en tiempo real en UTC/GMT para desarrolladores y trabajo remoto.

### 10. 👟 Steps Sync (`Steps/DoomScrollerSteps.ini` + `steps_server.py`)
- **Contador de Pasos**: Integración con servidor ligero en Python (`steps_server.py`) para recibir la cuenta de pasos diarios, distancia recorrida en km y calorías estimadas.

---

## 🚀 Guía de Instalación Paso a Paso

### 1. Requisitos Previos
* Descarga e instala **Rainmeter 4.5** o superior desde [Rainmeter.net](https://www.rainmeter.net/).

### 2. Copiar la Skin a Rainmeter
1. Clona o descarga este repositorio:
   ```bash
   git clone https://github.com/Nelxson2099/widgets-doomscroller.git
   ```
2. Copia la carpeta descargada a la ruta de skins de Rainmeter:
   ```text
   C:\Users\<TuUsuario>\Documents\Rainmeter\Skins\widget doomscroller
   ```

### 3. Activar los Widgets
1. Abre la ventana de administración de **Rainmeter** desde la bandeja del sistema.
2. Haz clic en **Refrescar todo** (*Refresh all*).
3. Despliega la carpeta **`widget doomscroller`**.
4. Entra en el módulo que desees (ej: `Weather`, `Moon`, `Habits`, `Circadian`) y presiona el botón **Cargar** (*Load*).

---

## ⚙️ Personalización & Ajustes

### Configuración Global (`@Resources/Variables.inc`)
Edita el archivo `@Resources/Variables.inc` con un editor de texto (Notepad, VS Code) para personalizar la suite:

```ini
[Variables]
; Fecha de Nacimiento para Memento Mori (YYYY-MM-DD)
BirthDate=2000-01-01
TargetAge=80

; Modo RGB Chroma (0 = Estático, 1 = Modo Arcoíris Dinámico)
RgbMode=0

; Color Accent Principal (R,G,B,A)
ColorAccent=255,160,0,255
ColorAccentGlow=255,160,0,40
```

### Configuración del Servidor de Pasos (`steps_server.py`)
Para sincronizar pasos vía HTTP POST desde tu teléfono o script local:
```bash
python @Resources/steps_server.py
```
El servidor escuchará en `http://localhost:8088/api/steps`.

---

## ⚡ Rendimiento & Bajo Consumo

* **Uso de CPU:** < 0.1% en reposo.
* **Consumo RAM:** < 15 MB por la suite completa.
* **Sin Lag:** Optimizado para no interferir en videojuegos ni tareas intensivas de renderizado.

---

## 📄 Licencia & Créditos

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo `LICENSE` para más detalles.

Desarrollado con ❤️ por **[Nelxson2099](https://github.com/Nelxson2099)** & **Antigravity AI**.  
*Dedicado a la comunidad de Rainmeter, la estética Glassmorphic y el biohacking.*
