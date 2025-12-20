import { describe, it, expect } from "vitest";
import { sanitizeValue, isValidCharacter, createPatternRegex } from "./controller.js";

describe("OTP Input - Business Logic", () => {
  describe("createPatternRegex", () => {
    it("creates regex from pattern with brackets", () => {
      const regex = createPatternRegex("[0-9]*");
      expect(regex.test("5")).toBe(true);
      expect(regex.test("a")).toBe(false);
    });

    it("creates regex from pattern without brackets", () => {
      const regex = createPatternRegex("0-9");
      expect(regex.test("5")).toBe(true);
      expect(regex.test("a")).toBe(false);
    });

    it("creates regex for alphanumeric pattern", () => {
      const regex = createPatternRegex("[0-9A-Za-z]*");
      expect(regex.test("5")).toBe(true);
      expect(regex.test("a")).toBe(true);
      expect(regex.test("Z")).toBe(true);
      expect(regex.test("-")).toBe(false);
    });
  });

  describe("isValidCharacter", () => {
    it("validates numeric characters", () => {
      const regex = createPatternRegex("[0-9]*");
      expect(isValidCharacter("0", regex)).toBe(true);
      expect(isValidCharacter("5", regex)).toBe(true);
      expect(isValidCharacter("9", regex)).toBe(true);
      expect(isValidCharacter("a", regex)).toBe(false);
      expect(isValidCharacter("Z", regex)).toBe(false);
      expect(isValidCharacter("-", regex)).toBe(false);
    });

    it("validates alphanumeric characters", () => {
      const regex = createPatternRegex("[0-9A-Za-z]*");
      expect(isValidCharacter("5", regex)).toBe(true);
      expect(isValidCharacter("a", regex)).toBe(true);
      expect(isValidCharacter("Z", regex)).toBe(true);
      expect(isValidCharacter("@", regex)).toBe(false);
      expect(isValidCharacter("#", regex)).toBe(false);
    });

    it("validates uppercase only pattern", () => {
      const regex = createPatternRegex("[A-Z]*");
      expect(isValidCharacter("A", regex)).toBe(true);
      expect(isValidCharacter("Z", regex)).toBe(true);
      expect(isValidCharacter("a", regex)).toBe(false);
      expect(isValidCharacter("5", regex)).toBe(false);
    });
  });

  describe("sanitizeValue", () => {
    const numericRegex = createPatternRegex("[0-9]*");
    const alphanumericRegex = createPatternRegex("[0-9A-Za-z]*");

    it("filters non-numeric characters from numeric pattern", () => {
      expect(sanitizeValue("1a2b3c", numericRegex, 6)).toBe("123");
      expect(sanitizeValue("abc123def", numericRegex, 6)).toBe("123");
      expect(sanitizeValue("!@#456", numericRegex, 6)).toBe("456");
    });

    it("preserves valid numeric characters", () => {
      expect(sanitizeValue("123456", numericRegex, 6)).toBe("123456");
      expect(sanitizeValue("000000", numericRegex, 6)).toBe("000000");
      expect(sanitizeValue("999888", numericRegex, 6)).toBe("999888");
    });

    it("truncates to specified length", () => {
      expect(sanitizeValue("123456789", numericRegex, 6)).toBe("123456");
      expect(sanitizeValue("12345678", numericRegex, 4)).toBe("1234");
      expect(sanitizeValue("999999999", numericRegex, 8)).toBe("99999999");
    });

    it("handles partial values", () => {
      expect(sanitizeValue("123", numericRegex, 6)).toBe("123");
      expect(sanitizeValue("1", numericRegex, 6)).toBe("1");
      expect(sanitizeValue("", numericRegex, 6)).toBe("");
    });

    it("handles alphanumeric pattern", () => {
      expect(sanitizeValue("1a2b3c", alphanumericRegex, 6)).toBe("1a2b3c");
      expect(sanitizeValue("ABC123", alphanumericRegex, 6)).toBe("ABC123");
      expect(sanitizeValue("a!b@c#", alphanumericRegex, 6)).toBe("abc");
    });

    it("combines filtering and truncation", () => {
      expect(sanitizeValue("1a2b3c4d5e6f7g", numericRegex, 6)).toBe("123456");
      expect(sanitizeValue("!!!111aaa222bbb333", numericRegex, 6)).toBe("111222");
    });

    it("handles empty and whitespace", () => {
      expect(sanitizeValue("", numericRegex, 6)).toBe("");
      expect(sanitizeValue("   ", numericRegex, 6)).toBe("");
      expect(sanitizeValue("1 2 3", numericRegex, 6)).toBe("123");
    });

    it("handles special characters", () => {
      expect(sanitizeValue("1-2-3-4-5-6", numericRegex, 6)).toBe("123456");
      expect(sanitizeValue("(555) 123-4567", numericRegex, 6)).toBe("555123");
    });
  });

  describe("Real-world scenarios", () => {
    const numericRegex = createPatternRegex("[0-9]*");

    it("sanitizes SMS code paste (123456)", () => {
      const result = sanitizeValue("123456", numericRegex, 6);
      expect(result).toBe("123456");
    });

    it("sanitizes email code with text (Your code is: 123456)", () => {
      const result = sanitizeValue("Your code is: 123456", numericRegex, 6);
      expect(result).toBe("123456");
    });

    it("sanitizes formatted code (123-456)", () => {
      const result = sanitizeValue("123-456", numericRegex, 6);
      expect(result).toBe("123456");
    });

    it("sanitizes code with spaces (1 2 3 4 5 6)", () => {
      const result = sanitizeValue("1 2 3 4 5 6", numericRegex, 6);
      expect(result).toBe("123456");
    });

    it("handles 4-digit PIN", () => {
      const result = sanitizeValue("1234", numericRegex, 4);
      expect(result).toBe("1234");
    });

    it("handles 8-digit code", () => {
      const result = sanitizeValue("12345678", numericRegex, 8);
      expect(result).toBe("12345678");
    });

    it("truncates code longer than expected", () => {
      const result = sanitizeValue("123456789", numericRegex, 6);
      expect(result).toBe("123456");
    });

    it("handles partial entry", () => {
      const result = sanitizeValue("123", numericRegex, 6);
      expect(result).toBe("123");
    });
  });

  describe("Edge cases", () => {
    const numericRegex = createPatternRegex("[0-9]*");

    it("handles undefined/null-like values", () => {
      expect(sanitizeValue("", numericRegex, 6)).toBe("");
    });

    it("handles very long input", () => {
      const longInput = "1234567890".repeat(100);
      const result = sanitizeValue(longInput, numericRegex, 6);
      expect(result).toBe("123456");
      expect(result.length).toBe(6);
    });

    it("handles all invalid characters", () => {
      expect(sanitizeValue("abcdef", numericRegex, 6)).toBe("");
      expect(sanitizeValue("!@#$%^", numericRegex, 6)).toBe("");
    });

    it("handles zero length", () => {
      expect(sanitizeValue("123456", numericRegex, 0)).toBe("");
    });

    it("handles length larger than input", () => {
      expect(sanitizeValue("123", numericRegex, 10)).toBe("123");
    });
  });
});
