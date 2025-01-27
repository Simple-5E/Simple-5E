const fs = require('fs').promises;

async function cleanSpellData(filePath) {
    try {
        // Read the input JSON file
        const data = await fs.readFile(filePath, 'utf8');
        const spells = JSON.parse(data);

        // Clean the spells data
        const cleanedSpells = spells.map(spell => {
            const cleanedSpell = {};
            
            // Process each property of the spell
            for (const [key, value] of Object.entries(spell)) {
                if (typeof value === 'string') {
                    // Remove markdown formatting
                    cleanedSpell[key] = value
                        .replace(/\*\*/g, '')  // Remove **
                        .replace(/\*/g, '')    // Remove single *
                        .replace(/\[([^\]]+)\]\([^\)]+\)/g, '$1')  // Replace [text](link) with just text
                        .trim();
                } else if (Array.isArray(value)) {
                    // Handle arrays (like classes)
                    cleanedSpell[key] = value.map(item => 
                        typeof item === 'string' 
                            ? item.replace(/\*\*/g, '').replace(/\*/g, '').trim()
                            : item
                    );
                } else {
                    // Keep other types as is
                    cleanedSpell[key] = value;
                }
            }
            
            return cleanedSpell;
        });

        // Write the cleaned data back to the same file
        await fs.writeFile(filePath, JSON.stringify(cleanedSpells, null, 2));
        console.log('Spell data has been cleaned and saved successfully!');

    } catch (error) {
        console.error('Error processing spell data:', error);
    }
}

const filePath = '../../assets/spells.json';
cleanSpellData(filePath);