import React, { useState } from 'react';
import LanguageDropdown from './components/LanguageDropdown.js';
import VoiceDropdown from './components/VoiceDropdown.js';
import EngineDropdown from './components/EngineDropdown.js';
import AudioPlayer from './components/AudioPlayer.js';
import './styles/global.css';  // Import the CSS file

const App = () => {
  const [text, setText] = useState('');
  const [selectedLanguage, setSelectedLanguage] = useState('en-US');
  const [selectedVoice, setSelectedVoice] = useState('');  // Initially empty
  const [selectedEngine, setSelectedEngine] = useState('standard'); // Default engine
  const [audioUrl, setAudioUrl] = useState(null);

  const handleSynthesize = async () => {
    setAudioUrl(null);
    // Send data to your Lambda function
    try {
      const response = await fetch(process.env.AG_ENDPOINT, {  // Replace with your Lambda endpoint
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          text,
          voice: selectedVoice,
          language: selectedLanguage,
          engine: selectedEngine
        }),
      });
      const data = await response.json();
      const binaryString = atob(JSON.parse(data.body).audio); // Decode Base64 string to binary
      const byteArray = new Uint8Array(binaryString.length);
  
      for (let i = 0; i < binaryString.length; i++) {
        byteArray[i] = binaryString.charCodeAt(i);
      }
  
      const audioBlob = new Blob([byteArray], { type: 'audio/mp3' });
      const audioUrl = URL.createObjectURL(audioBlob); // Create a URL for the Blob
      setAudioUrl(audioUrl);
        } catch (error) {
      console.error("Error synthesizing speech:", error);
      // Handle errors appropriately (e.g., display an error message)
    }
  };


  return (
    <div className="app-container"> {/* Use className for styling */}
      <h1>Text-to-Speech</h1>
      <textarea
        value={text}
        onChange={(e) => setText(e.target.value)}
        placeholder="Enter text here..."
      />

      <LanguageDropdown selected={selectedLanguage} onChange={setSelectedLanguage} />
      <EngineDropdown selected={selectedEngine} onChange={setSelectedEngine} />
      <VoiceDropdown
        selectedLanguage={selectedLanguage} // Pass selected language for filtering
        selectedEngine={selectedEngine}
        selected={selectedVoice}
        onChange={setSelectedVoice}
      />

      <button onClick={handleSynthesize} disabled={!selectedVoice}>Synthesize</button> {/* Disable if no voice is selected */}

      {audioUrl && <AudioPlayer audioUrl={audioUrl} />}
    </div>
  );
};

export default App;