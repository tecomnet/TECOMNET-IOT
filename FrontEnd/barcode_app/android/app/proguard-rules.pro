# ML Kit Vision Text (solo se usa el reconocedor latino)
-keep class com.google.mlkit.vision.text.** { *; }

# El plugin referencia los reconocedores de otros alfabetos, que no se incluyen
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
