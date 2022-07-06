import secretHitler

sHitler = secretHitler.SecretHitler("http://localhost:8000")

b = sHitler.newPlayer("Bertik23")

print(b.token)

print(sHitler.createSlot(b))
print(b.createSlot())


input("A")
del sHitler
print("B")
