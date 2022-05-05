from cgitb import text
import sys
import os
import wave

from torch import batch_norm_stats
sys.path.insert(0, os.path.join(os.getcwd(), "pytorch"))

from parts.manifest import Manifest
from parts.segment import AudioSegment

import numpy as np

import mlperf_loadgen as lg


class AudioQSL:
    def __init__(self, dataset_dir, manifest_filepath, labels,
                 sample_rate=16000, perf_count=None):
        m_paths = [manifest_filepath]
        self.manifest = Manifest(dataset_dir, m_paths, labels, len(labels),
                                 normalize=True, max_duration=15.0)
        self.sample_rate = sample_rate
        self.count = len(self.manifest)
        perf_count = self.count if perf_count is None else perf_count
        self.sample_id_to_sample = {}
        self.transcripts = {}
        self.load_query_samples(range(self.count))
        self.qsl = lg.ConstructQSL(self.count, perf_count,
                                   self.load_query_samples,
                                   self.unload_query_samples)

        print(
            "Dataset loaded with {0:.2f} hours. Filtered {1:.2f} hours. Number of samples: {2}".format(
                self.manifest.duration / 3600,
                self.manifest.filtered_duration / 3600,
                self.count))

    def load_query_samples(self, sample_list):
        for sample_id in sample_list:
            self.sample_id_to_sample[sample_id] = self._load_sample(sample_id)
            self.transcripts[sample_id] = self.manifest[sample_id]['transcript']

    def unload_query_samples(self, sample_list):
        for sample_id in sample_list:
            del self.sample_id_to_sample[sample_id]

    def _load_sample(self, index):
        sample = self.manifest[index]
        segment = AudioSegment.from_file(sample['audio_filepath'][0],
                                         target_sr=self.sample_rate)
        waveform = segment.samples
        assert isinstance(waveform, np.ndarray) and waveform.dtype == np.float32
        return waveform

    def __getitem__(self, index):
        batch = []
        waveform_length = []
        batch_text = []
        text_len = []
        max_len = 0
        for i in index:
            batch.append(self.sample_id_to_sample[i])
            waveform_length.append(len(self.sample_id_to_sample[i]))
            batch_text.append(self.transcripts[i])
            text_len.append(len(self.transcripts[i]))
        # for idx, sample in enumerate(batch):
            # if sample.shape[0] > max_len:
                # max_len = sample.shape[0]
                # max_txt_len = batch_text
        max_len = np.max(waveform_length)
        max_txt_len = np.max(text_len)
        for i in range(len(batch)):
            padded_array = np.zeros((max_len,))
            padded_array_txt = np.zeros((max_txt_len,))
            shape = np.shape(batch[i])
            padded_array[:shape[0],] = batch[i]
            batch[i] = padded_array   
            shape = np.shape(batch_text[i])
            padded_array_txt[:shape[0],] = batch_text[i]
            batch_text[i] = padded_array_txt          
        # return self.sample_id_to_sample[index]
        return np.array(batch), np.array(waveform_length), np.array(batch_text), np.array(text_len)

    def __del__(self):
        lg.DestroyQSL(self.qsl)
        print("Finished destroying QSL.")

# EAGLE: This implementation is taken for inference code of MLPerf-RNNT. 
# EAGLE: For inference, memory fits data easilty but for training, 
# EAGLE: it requires more than 20GB with batch size 8.
# We have no problem fitting all data in memory, so we do that, in
# order to speed up execution of the benchmark.
class AudioQSLInMemory(AudioQSL):
    def __init__(self, dataset_dir, manifest_filepath, labels,
                 sample_rate=16000, perf_count=None):
        super().__init__(dataset_dir, manifest_filepath, labels,
                         sample_rate, perf_count)
        super().load_query_samples(range(self.count))

    def load_query_samples(self, sample_list):
        pass

    def unload_query_samples(self, sample_list):
        pass
