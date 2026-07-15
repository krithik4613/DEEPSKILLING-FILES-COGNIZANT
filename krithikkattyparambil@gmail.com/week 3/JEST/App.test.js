const greet = require('./App');
const fetchUser = require('./api');

test("Greeting Function", () => {
    expect(greet("Abinithin")).toBe("Hello, Abinithin!");
});

test("Mock API Call", async () => {

    jest.spyOn(require('./api'), 'fetchUser');

    const user = await fetchUser();

    expect(user.name).toBe("Abinithin");
});