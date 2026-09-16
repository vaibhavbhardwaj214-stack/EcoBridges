# AI Scan Testing Guide

## Quick Test Instructions

### Prerequisites
✅ Dev server is running (http://localhost:5174/ for frontend, port 3001 for backend)
✅ Gemini API key is configured in `.env`
✅ Database is connected and has material categories

### Test Steps

#### Test 1: Basic Material Detection (Copper Wire)

1. **Open the app** at http://localhost:5174/
2. **Navigate to AI Scan feature** (look for "📸 AI Scan" or "Material Detection")
3. **Capture or upload** a photo of copper wire/metal
4. **Observe the result**:
   - Should detect "Copper" (or तांबा in Hindi)
   - Confidence score should be > 0.6
   - Should show market rate (₹ per kg)
   - Should show carbon impact
5. **Check browser console** for logs:
   ```
   [Frontend] Captured image: {...}
   [Frontend] Image hash: <number>
   [Frontend] Backend response: {...}
   ```
6. **Check backend logs** in terminal:
   ```
   [AI Scan] Request received: {...}
   [Gemini Vision] Image hash: <number>
   [Gemini Vision] RAW Gemini Response: {...}
   [AI Scan] Detected material: copper
   ```

#### Test 2: Different Material (Paper/Newspaper)

1. **Capture** a photo of newspaper or paper
2. **Observe the result**:
   - Should detect "Newspaper" or "Paper"
   - Should be DIFFERENT from Test 1 result
   - Different hash, different material, different rate
3. **Verify in console**:
   - Image hash is different
   - `material_category_id` is NOT "copper"

#### Test 3: Unrecognized Material

1. **Capture** a photo of:
   - A person's face
   - A blank wall
   - A document/form
   - Something unrelated to scrap
2. **Observe the result**:
   - Should show "Unrecognized" or "पहचान नहीं हुई"
   - Confidence score < 0.4
   - Warning UI should appear
   - Should suggest retry or manual entry
3. **Verify behavior**:
   - No fake material returned
   - No hardcoded "Copper, 50%" result
   - Clear user guidance provided

#### Test 4: Same Photo (Consistency Check)

1. **Use the exact same photo** from Test 1
2. **Verify**:
   - Same material detected
   - Same confidence score
   - Same hash logged
   - Proves no random/state issues

### Manual API Testing with curl (Advanced)

If you want to test the backend directly:

```bash
# Test with a base64 image (replace <BASE64_DATA> with actual base64)
curl -X POST http://localhost:3001/api/v1/ai/scan \
  -H "Content-Type: application/json" \
  -d '{
    "imageBase64": "<BASE64_DATA>",
    "lang": "hi"
  }'
```

Expected response:
```json
{
  "success": true,
  "material_category_id": "copper",
  "material_name": "तांबा",
  "rate_per_kg": 540,
  "ai_confidence": 0.85,
  "detected_label": "Copper wire",
  "carbon_emission_per_kg": 2.5,
  "environmental_impact": {
    "carbon_saved_per_kg": 2.5,
    "description": "इस सामग्री को रीसाइकल करने से 2.5kg CO₂ बचेगा"
  },
  "model": "gemini-3.5-flash",
  "fallback": false
}
```

### Testing Checklist

- [ ] Test 1: Material detected correctly (not hardcoded)
- [ ] Test 2: Different photo returns different material
- [ ] Test 3: Unrecognized state works properly
- [ ] Test 4: Same photo returns consistent results
- [ ] Console logs show actual processing (image hash, Gemini response)
- [ ] Backend logs show detection flow
- [ ] Confidence scores reflect image quality
- [ ] Multi-language works (try EN, HI, MR)
- [ ] Rate and carbon data come from database
- [ ] Safety tips displayed correctly
- [ ] Retry button works for unrecognized items
- [ ] No 404 or "endpoint not found" errors

### Common Issues and Solutions

#### Issue: "Endpoint not found"
**Solution:** Verify backend is running on port 3001 and frontend is proxying correctly to `/api/v1/`

#### Issue: "GEMINI_API_KEY not configured"
**Solution:** Check `.env` file has valid `GEMINI_API_KEY=AIza...`

#### Issue: All scans return "Copper"
**Solution:** Check backend logs - if you see hardcoded responses, the fix was not applied. Review `backend/src/routes/ai.routes.ts`

#### Issue: Always returns "unrecognized"
**Solution:** 
1. Check Gemini API key is valid
2. Check image quality (try better lighting)
3. Verify categories exist in database
4. Check backend logs for actual Gemini response

#### Issue: Camera permission denied
**Solution:** 
1. Check browser permissions
2. Use HTTPS or localhost (required for camera access)
3. Try file upload instead

### Expected Console Logs

**Frontend (Browser Console):**
```
[Frontend] Captured image: {
  base64Length: 12345,
  blobSize: 9876,
  canvasSize: "640x480",
  firstChars: "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBD...",
  lastChars: "...UVORK5CYII="
}
[Frontend] Image hash: -1234567890
[Frontend] Sending to backend: { imageBase64Length: 12345, lang: "hi" }
[Frontend] Backend response: {
  success: true,
  material_category_id: "copper",
  material_name: "तांबा",
  ai_confidence: 0.85,
  ...
}
```

**Backend (Terminal):**
```
[AI Scan] Request received: { hasPhotoUrl: false, hasImageBase64: true, imageBase64Length: 12345, lang: "hi" }
[AI Scan] Loaded categories: iron, copper, newspaper, pet_bottles, ...
[AI Scan] Processing image with base64 data...
[AI Scan] Attempting Gemini Vision API...
[Gemini Vision] Image received: { length: 12345, ... }
[Gemini Vision] Image hash: -1234567890
[Gemini Vision] Using dynamic category list from database
[Gemini] Attempting model: gemini-3.5-flash
[Gemini] Response status: 200 OK
[Gemini] ✅ SUCCESS with model: gemini-3.5-flash
[Gemini Vision] RAW Gemini Response: {"material":"copper","label":"Copper wire coils","confidence":0.85}
[Gemini Vision] Parsed result: { material: "copper", label: "Copper wire coils", confidence: 0.85 }
[Gemini Vision] success: true
[AI Scan] Detected material: copper → Matched: copper (Copper)
[AI Scan] Sending response: {
  success: true,
  material_category_id: "copper",
  material_name: "तांबा",
  rate_per_kg: 540,
  ai_confidence: 0.85,
  ...
}
```

### Success Criteria

✅ **All tests pass** without errors
✅ **Different photos return different materials** (proves no hardcoding)
✅ **Confidence scores vary** based on image quality
✅ **Unrecognized state works** for non-material images
✅ **Logs show actual processing** (not cached responses)
✅ **Multi-language works** correctly
✅ **No fake/hardcoded results** at any point

---

## Debugging Tips

1. **Enable verbose logging**: Check both browser console and backend terminal
2. **Compare image hashes**: Same photo should have same hash
3. **Check Gemini response**: Look for `[Gemini Vision] RAW Gemini Response` in logs
4. **Verify database categories**: Run `SELECT * FROM material_categories;` in database
5. **Test with different images**: Try clear, high-quality photos first
6. **Check network tab**: Look for `/api/v1/ai/scan` requests and responses

## Contact & Support

If you encounter issues:
1. Check `AI_SCAN_VERIFICATION_REPORT.md` for detailed implementation info
2. Review backend logs for error messages
3. Verify Gemini API key is valid
4. Ensure database connection is working
5. Check that all dependencies are installed (`npm install` in root, frontend, and backend)
