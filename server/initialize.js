import express, { urlencoded } from "express";
import { config } from "dotenv";
import cors from "cors";

// env
config();

const app = express();

app.use(express.json());
app.use(urlencoded({ extended: true }));
app.use(
	cors({
		origin: "*",
	})
);

export { app };
