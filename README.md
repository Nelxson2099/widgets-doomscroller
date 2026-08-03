# 💀 DoomScroller - Suite de Widgets para Rainmeter (PC)

Suite de widgets minimalistas de alto rendimiento para Windows PC con estética **Dark Glassmorphic**, consumo ultra-bajo (< 0.1% CPU / RAM) y actualización en vivo.

---

## 🌟 Widgets Incluidos en la Suite

### 1. 🌤️ **Clima Caracas (`Weather\DoomScrollerWeather.ini`)**
- **Meteorología en Vivo de Caracas, Venezuela**: Integración directa con la API de Open-Meteo para las coordenadas exactas de Caracas (10.48°N, -66.90°W).
- **Pronóstico de Hoy y Mañana**:
  - **Hoy**: Temperatura actual en vivo, sensación térmica, viento (km/h), humedad, condición del clima y rango Máx/Mín.
  - **Mañana**: Pronóstico de 24 horas, rango térmico y barra gráfica animada de probabilidad de lluvia.
- **Estética Neon Purple**: Cristal oscuro con detalles en morado neón y dorado de alta legibilidad sin errores de codificación.

### 2. 🌙 **Fase Lunar (`Moon\DoomScrollerMoon.ini`)**
- **Esfera Lunar Dinámica**: Cálculo astronómico de precisión en tiempo real de la fase lunar actual (Luna Llena, Creciente, Menguante, etc.).
- **Esfera Interactiva**: Esfera gráfica central que ajusta dinámicamente su iluminación y núcleo visual en porcentaje exacto (%).
- **Próxima Fase**: Cuenta regresiva de días para el próximo cambio de fase principal.

### 3. 🧬 **Reloj Circadiano en Vivo (`Circadian\DoomScrollerCircadian.ini`)**
- **Biometría en Tiempo Real**: Rastreo dinámico de las 6 hormonas y métricas circadianas principales (Cortisol, Melatonina, Presión de Sueño, Hormona de Crecimiento, Temperatura Corporal y Sensibilidad a la Insulina).
- **Fase del Día Actual**: Indica la fase biológica activa (ej. *Pico de Testosterona*, *Ventana Proteica*, *Melatonina en Asenso*) y temporizador para el próximo hito.

### 4. ⏳ **Memento Mori (`Memento\DoomScrollerMemento.ini`)**
- **Conciencia del Tiempo**: Muestra días vividos, semanas transcurridas, semana actual del año (1-52) y barra de progreso de vida basada en expectativa configurable.

### 5. ✅ **Habit Flow (`Habits\DoomScrollerHabits.ini`)**
- **Rastreador de Hábitos**: Panel interactivo con switches visuales para marcar tus objetivos y hábitos diarios directamente en el escritorio.

### 6. 🎵 **Audio Visualizer (`Visualizer\DoomScrollerAudioPlayer.ini`)**
- **Visualizador de Audio RGB**: Espectro de ondas sonoras reactivo a la música o sonido de tu PC con modos RGB Chroma.

---

## 🚀 Instalación y Carga en Rainmeter

1. Los archivos se encuentran sincronizados automáticamente en la carpeta de skins de Rainmeter:
   `C:\Users\<TuUsuario>\Documents\Rainmeter\Skins\widget doomscroller`
2. Abre la ventana principal de **Rainmeter**.
3. Haz clic en **Refrescar todo** (*Refresh all*).
4. Despliega la carpeta `widget doomscroller`.
5. Selecciona el widget que deseas activar (`Weather`, `Moon`, `Circadian`, `Memento`, `Habits` o `Visualizer`) y haz clic en **Cargar** (*Load*).

---

## ⚙️ Personalización y Configuración

- **Configuración Global**: Abre `@Resources\Variables.inc` para cambiar la fecha de nacimiento (`BirthDate`), modo RGB (`RgbMode`), o la paleta de colores base.
- **Menú Contextual**: Haz clic derecho sobre cualquier widget para acceder a acciones rápidas como refrescar el clima, activar modo RGB o ajustar valores.
