package br.com.mottu.mottuvision.controller;

import br.com.mottu.mottuvision.dto.MotoDTO;
import br.com.mottu.mottuvision.entity.Filial;
import br.com.mottu.mottuvision.entity.Moto;
import br.com.mottu.mottuvision.entity.MotoStatus;
import br.com.mottu.mottuvision.repository.FilialRepository;
import br.com.mottu.mottuvision.repository.MotoRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * REST Controller para operações CRUD de Motos
 * Endpoints públicos para demonstração (em produção, adicionar autenticação)
 */
@RestController
@RequestMapping("/api/motos")
public class MotoRestController {

    private final MotoRepository motoRepository;
    private final FilialRepository filialRepository;

    public MotoRestController(MotoRepository motoRepository, FilialRepository filialRepository) {
        this.motoRepository = motoRepository;
        this.filialRepository = filialRepository;
    }

    /**
     * GET /api/motos - Lista todas as motos
     */
    @GetMapping
    public ResponseEntity<List<MotoDTO>> listarTodasMotos() {
        List<Moto> motos = motoRepository.findAll();
        List<MotoDTO> motosDTO = motos.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(motosDTO);
    }

    /**
     * GET /api/motos/{id} - Busca moto por ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<MotoDTO> buscarMotoPorId(@PathVariable Long id) {
        return motoRepository.findById(id)
                .map(moto -> ResponseEntity.ok(convertToDTO(moto)))
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * POST /api/motos - Cria nova moto
     */
    @PostMapping
    public ResponseEntity<MotoDTO> criarMoto(@RequestBody MotoDTO motoDTO) {
        try {
            // Validar filial
            Filial filial = filialRepository.findById(motoDTO.getFilialId())
                    .orElseThrow(() -> new IllegalArgumentException("Filial não encontrada"));

            // Criar nova moto
            Moto moto = new Moto();
            moto.setPlaca(motoDTO.getPlaca());
            moto.setModelo(motoDTO.getModelo());
            moto.setAno(motoDTO.getAno());
            moto.setFilial(filial);
            moto.setStatus(MotoStatus.valueOf(motoDTO.getStatus()));
            moto.setPosicaoX(motoDTO.getPosicaoX());
            moto.setPosicaoY(motoDTO.getPosicaoY());
            moto.setUltimaAtualizacao(LocalDateTime.now());

            Moto savedMoto = motoRepository.save(moto);
            return ResponseEntity.status(HttpStatus.CREATED).body(convertToDTO(savedMoto));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * PUT /api/motos/{id} - Atualiza moto existente
     */
    @PutMapping("/{id}")
    public ResponseEntity<MotoDTO> atualizarMoto(@PathVariable Long id, @RequestBody MotoDTO motoDTO) {
        return motoRepository.findById(id)
                .map(moto -> {
                    // Atualizar campos
                    moto.setPlaca(motoDTO.getPlaca());
                    moto.setModelo(motoDTO.getModelo());
                    moto.setAno(motoDTO.getAno());
                    moto.setStatus(MotoStatus.valueOf(motoDTO.getStatus()));
                    moto.setPosicaoX(motoDTO.getPosicaoX());
                    moto.setPosicaoY(motoDTO.getPosicaoY());
                    moto.setUltimaAtualizacao(LocalDateTime.now());

                    // Atualizar filial se necessário
                    if (motoDTO.getFilialId() != null && !moto.getFilial().getId().equals(motoDTO.getFilialId())) {
                        Filial novaFilial = filialRepository.findById(motoDTO.getFilialId())
                                .orElseThrow(() -> new IllegalArgumentException("Filial não encontrada"));
                        moto.setFilial(novaFilial);
                    }

                    Moto updatedMoto = motoRepository.save(moto);
                    return ResponseEntity.ok(convertToDTO(updatedMoto));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * DELETE /api/motos/{id} - Deleta moto
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarMoto(@PathVariable Long id) {
        return motoRepository.findById(id)
                .map(moto -> {
                    motoRepository.delete(moto);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Converte Moto para MotoDTO
     */
    private MotoDTO convertToDTO(Moto moto) {
        MotoDTO dto = new MotoDTO();
        dto.setId(moto.getId());
        dto.setPlaca(moto.getPlaca());
        dto.setModelo(moto.getModelo());
        dto.setAno(moto.getAno());
        dto.setFilialId(moto.getFilial().getId());
        dto.setFilialNome(moto.getFilial().getNome());
        dto.setStatus(moto.getStatus().name());
        dto.setPosicaoX(moto.getPosicaoX());
        dto.setPosicaoY(moto.getPosicaoY());
        dto.setUltimaAtualizacao(moto.getUltimaAtualizacao());
        return dto;
    }
}
