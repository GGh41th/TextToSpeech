const AudioPlayer = ({ audioUrl }) => (
    <audio controls>
      <source src={audioUrl} type="audio/mp3" />
      Your browser does not support the audio element.
    </audio>
  );
  
  export default AudioPlayer;