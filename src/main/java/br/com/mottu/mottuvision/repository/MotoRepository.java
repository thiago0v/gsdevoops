package br.com.mottu.mottuvision.repository;

import br.com.mottu.mottuvision.entity.Moto;
import br.com.mottu.mottuvision.entity.Filial;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MotoRepository extends JpaRepository<Moto, Long> {
    List<Moto> findByFilial(Filial filial);
    Optional<Moto> findByPlaca(String placa);
}
