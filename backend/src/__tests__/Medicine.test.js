const request = require("supertest");
const app = require("../../app");

jest.mock("../config/db", () => ({
  query: jest.fn(),
}));

const db = require("../config/db");

describe("GET /", () => {
  it("returns a welcome message with success: true", async () => {
    const res = await request(app).get("/");
    expect(res.statusCode).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.message).toBe("Welcome to MedStock Monitor API");
  });
});

describe("GET /api/medicines", () => {
  it("returns all medicines as an array", async () => {
    db.query.mockResolvedValueOnce({
      rows: [
        { id: 1, name: "Paracetamol", category: "Analgesics", quantity: 120, threshold: 20 },
        { id: 2, name: "Amoxicillin", category: "Antibiotics", quantity: 30, threshold: 15 },
      ],
    });

    const res = await request(app).get("/api/medicines");
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body.data)).toBe(true);
  });

  it("returns 404 for a route that does not exist", async () => {
    const res = await request(app).get("/api/nonexistent");
    expect(res.statusCode).toBe(404);
  });
});

describe("GET /api/medicines/:id", () => {
  it("returns a single medicine when it exists", async () => {
    db.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: "Paracetamol", category: "Analgesics", quantity: 120, threshold: 20 }],
    });

    const res = await request(app).get("/api/medicines/1");
    expect(res.statusCode).toBe(200);
  });

  it("returns 404 when medicine is not found", async () => {
    db.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get("/api/medicines/9999");
    expect(res.statusCode).toBe(404);
  });
});

describe("GET /api/medicines/alerts/low-stock", () => {
  it("returns medicines where quantity is below threshold", async () => {
    db.query.mockResolvedValueOnce({
      rows: [
        { id: 3, name: "Coartem", category: "Antimalarials", quantity: 8, threshold: 10 },
      ],
    });

    const res = await request(app).get("/api/medicines/alerts/low-stock");
    expect(res.statusCode).toBe(200);
  });
});