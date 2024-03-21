package middleware

import (
    "github.com/golang-jwt/jwt/v5"
    "github.com/gin-gonic/gin"
    "net/http"
    "os"
	"fmt"
	"strings"
)

func AuthMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        tokenString := c.GetHeader("Authorization")
        // Typically, the Authorization header is in the format "Bearer <token>"
        // You may need to strip "Bearer " from the tokenString
        
        // Strip "Bearer " prefix if it exists
        if strings.HasPrefix(tokenString, "Bearer ") {
            tokenString = strings.TrimPrefix(tokenString, "Bearer ")
        }

        token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
            // Make sure token's signing method is what you expect
            if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
                return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
            }

            return []byte(os.Getenv("SECRET")), nil
        })

        if err != nil {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
            c.Abort() // Prevents the handler from being called
            return
        }

        if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
            // Extract user information from claims and attach it to the context
            userID := claims["sub"]
            c.Set("userID", userID)
            c.Next()
        } else {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
            c.Abort() // Prevents the handler from being called
            return
        }
    }
}