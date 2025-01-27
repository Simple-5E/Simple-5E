import Replicate from "replicate";
import { writeFile, access } from "node:fs/promises";
import { mkdir } from "node:fs/promises";
import path from "path";
import readline from "readline";

const replicate = new Replicate();
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const question = (query) => new Promise((resolve) => rl.question(query, resolve));

const races = [
  "dragonborn",
  "dwarf", 
  "elf",
  "gnome",
  "half-elf",
  "halfling",
  "half-orc",
  "human",
  "tiefling"
];

const types = ["masculine", "feminine"];

function generatePrompt(race, type, extraPrompts = "") {
  const basePrompt = `fantasy portrait of a ${type} ${race}, modern digital art style`;
  
  const details = [
    `distinctive ${race} features`,
    "expressive face",
    "symmetrical features",
    "natural pose",
    "clean design"
  ].join(", ");

  const style = [
    "vibrant colors",
    "crisp digital rendering",
    "well-lit",
    "clear details",
    "modern fantasy art"
  ].join(", ");

  const background = [
    "warm cozy tavern background",
    "wooden walls",
    "soft ambient lighting",
    "slightly out of focus background",
    "medieval fantasy inn setting"
  ].join(", ");

  const extraPromptStr = extraPrompts ? `, ${extraPrompts}` : '';
  return `${basePrompt}, ${details}, ${style}, ${background}, head and shoulders portrait, front view, shallow depth of field${extraPromptStr}`;
}

async function ensureDir(dirPath) {
  try {
    await mkdir(dirPath, { recursive: true });
  } catch (error) {
    if (error.code !== 'EEXIST') throw error;
  }
}

async function fileExists(filePath) {
  try {
    await access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function generateImage(race, type, input, extraPrompts = "") {
  console.log(`Generating ${type} ${race}...`);
  const output = await replicate.run("recraft-ai/recraft-v3", { input });
  console.log(`Generated image URL: ${output}`);
  
  const answer = await question("Are you happy with this image? (y/n): ");
  if (answer.toLowerCase() === 'y') {
    return output;
  }
  
  const modifications = await question("Enter additional prompt details (or press enter to retry without changes): ");
  const newExtraPrompts = modifications ? 
    (extraPrompts ? `${extraPrompts}, ${modifications}` : modifications) : 
    extraPrompts;
  
  console.log("Regenerating image...");
  const newInput = {
    ...input,
    prompt: generatePrompt(race, type, newExtraPrompts)
  };
  return generateImage(race, type, newInput, newExtraPrompts);
}

async function generateAllRaceAssets() {
  const outputDir = path.join(process.cwd(), "../../assets", "races");
  await ensureDir(outputDir);

  for (const race of races) {
    console.log(`Checking assets for ${race}...`);
    
    for (const type of types) {
      const filename = `${race}_${type === "masculine" ? 1 : 2}.webp`;
      const filepath = path.join(outputDir, filename);

      if (await fileExists(filepath)) {
        console.log(`✓ ${filename} already exists, skipping...`);
        continue;
      }

      try {
        const input = {
          size: "1024x1024",
          prompt: generatePrompt(race, type)
        };

        const output = await generateImage(race, type, input);
        
        await writeFile(filepath, output);
        console.log(`✓ Saved ${filename}`);
        
        await new Promise(resolve => setTimeout(resolve, 2000));
        
      } catch (error) {
        console.error(`Error generating ${type} ${race}:`, error);
      }
    }
  }
  rl.close();
}

generateAllRaceAssets()
  .then(() => console.log('All assets generated successfully!'))
  .catch(error => console.error('Error generating assets:', error));